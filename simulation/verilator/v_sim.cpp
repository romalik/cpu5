
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <vector>
#include <iostream>
#include <signal.h>
#include <atomic>
#include <thread>
#include <vector>
#include <mutex>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <queue>
#include "devices.hpp"

#ifndef VSIM_TRACE
#define VSIM_TRACE 0
#endif


#include "verilated.h"

#if VSIM_TRACE
#include "verilated_vcd_c.h"
#endif

// ---- CHANGE HERE if your top module isn't 'cpu5' ----
#include "Vcpu5.h"
using Top = Vcpu5;
// -----------------------------------------------------


// Global simulation time in ps
static vluint64_t main_time_ps = 0;
double sc_time_stamp() { return main_time_ps; }

static inline vluint64_t ns_to_ps(double ns) {
    if (ns <= 0) return 0;
    double ps = ns * 1000.0;
    if (ps < 0) ps = 0;
    return static_cast<vluint64_t>(std::llround(ps));
}

struct SimCfg {
    double period_ns = 10.0;
    double t1_reset_low_ns = 20.0;
    double t2_run_ns       = 10000000.0;
    bool   rst_active_low  = true;
    std::string vcd_path   = "v_cpu5.vcd";
};





keyboard kb;
SimpleStorage storage;


int decode_mem(uint16_t addr) {
    if(addr >= 0x8000) {
        return 0;
    }
    switch(addr) {
        case 0x4803:
        case 0x4804:
        case 0x4000:
        case 0x4001:
        case 0x4002:
            return 1;
            break;
        default:
            return 0;
    }
}

void mem_write(uint16_t addr, uint8_t val) {
    if(addr == 0x4803) {
        printf("%c", val);
        fflush(stdout);
    } else if (addr == 0x4000) {
        storage.set_low_addr(val);
    } else if (addr == 0x4001) {
        storage.set_mid_addr(val);
    } else if (addr == 0x4002) {
        storage.set_high_addr(val);
    } else if (addr == 0x4804) {
        storage.write(val);
    } else {
        printf("Decode error!\n");

    }
}


uint8_t mem_read(uint16_t addr) {
    if(addr == 0x4803) {
        if(kb.has_data()) {
            uint8_t c = kb.pop();
            //printf(" --- read kb 0x%02x ---\n", c);
            return c;
        } else {
            return 0;
        }
    } else if (addr == 0x4804) {
        return storage.read();
    } else {
        printf("Decode error!\n");
        return 0;
    }
}




std::atomic<bool> stop_flag(false);


void sigint_handler(int signum) {
    if (signum == SIGINT) {
        stop_flag.store(true, std::memory_order_relaxed);
    }
}


struct Args {
    std::string rom;
    std::string hdd;
    std::string fw{"."};
};

Args parse_args(int argc, char* argv[]) {
    Args args;
    for (int i = 1; i < argc; ++i) {
        std::string key = argv[i];
        if ((key == "--rom") && i + 1 < argc) {
            args.rom = argv[++i]; // eat next arg
        } else if ((key == "--hdd") && i + 1 < argc) {
            args.hdd = argv[++i];
        } else if ((key == "--fw") && i + 1 < argc) {
            args.fw = argv[++i];
        }
    }
    return args;
}



int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);


    signal(SIGINT, sigint_handler);
    SimCfg cfg;

    size_t tick_n = 0;

    const vluint64_t half_period_ps = ns_to_ps(cfg.period_ns) / 2;

    Top* top = new Top;


#if VSIM_TRACE
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open(cfg.vcd_path.c_str());
    printf("Tracing enabled\n");
#endif


    top->SIM_OE = 1;

    Args args = parse_args(argc,argv);



    verilator_mem_init(args.fw);


    if(args.hdd.empty()) {
        storage.init(65536*256);
    } else {
        storage.load(args.hdd);
    }



    auto eval_dump = [&](){
        top->eval();
#if VSIM_TRACE        
        tfp->dump(main_time_ps);
#endif
    };

    auto set_data = [&](uint8_t v) {
        top->SIM_DATA0 = (v & 0b00000001) >> 0;
        top->SIM_DATA1 = (v & 0b00000010) >> 1;
        top->SIM_DATA2 = (v & 0b00000100) >> 2;
        top->SIM_DATA3 = (v & 0b00001000) >> 3;
        top->SIM_DATA4 = (v & 0b00010000) >> 4;
        top->SIM_DATA5 = (v & 0b00100000) >> 5;
        top->SIM_DATA6 = (v & 0b01000000) >> 6;
        top->SIM_DATA7 = (v & 0b10000000) >> 7;
    };

    auto get_address = [&]() -> uint16_t {
        uint16_t v = 
            (top->ADDR0  <<  0) |
            (top->ADDR1  <<  1) |
            (top->ADDR2  <<  2) |
            (top->ADDR3  <<  3) |
            (top->ADDR4  <<  4) |
            (top->ADDR5  <<  5) |
            (top->ADDR6  <<  6) |
            (top->ADDR7  <<  7) |
            (top->ADDR8  <<  8) |
            (top->ADDR9  <<  9) |
            (top->ADDR10 << 10) |
            (top->ADDR11 << 11) |
            (top->ADDR12 << 12) |
            (top->ADDR13 << 13) |
            (top->ADDR14 << 14) |
            (top->ADDR15 << 15) ;
        return v;
    };

    auto get_data = [&]() -> uint16_t {
        uint16_t v = 
            (top->DATA0  <<  0) |
            (top->DATA1  <<  1) |
            (top->DATA2  <<  2) |
            (top->DATA3  <<  3) |
            (top->DATA4  <<  4) |
            (top->DATA5  <<  5) |
            (top->DATA6  <<  6) |
            (top->DATA7  <<  7) ;
        return v;
    };


    auto tick = [&](){
        /*
        top->iDATA0 = 1; //nop
        top->iDATA1 = 1; //nop
        top->iDATA2 = 0; //nop
        top->iDATA3 = 0; //nop
        top->iDATA4 = 0; //nop
        top->iDATA5 = 0; //nop
        top->iDATA6 = 0; //nop
        top->iDATA7 = 0; //nop
        */

        //printf("0x%04x : RD(%d) WR(%d)\n", SIM_A, SIM_RD, SIM_WR);


        if(kb.has_data()) {
            //printf("++ int3 ++\n");            
            top->INT3 = 1;
        } else {
            top->INT3 = 0;
        }

        if((tick_n & 0xfffff) == 0) {
            //printf("++ int0 ++\n");
            top->INT0 = 1;
        } else {
            top->INT0 = 0;
        }

        static int prev_mread = 1;
        int mread_fall = 0;
        int mread_rise = 0;

        if(prev_mread == 1 && top->MREAD == 0) {
            mread_fall = 1;
        }

        if(prev_mread == 0 && top->MREAD == 1) {
            mread_rise = 1;
        }

        prev_mread = top->MREAD;

        if(mread_fall) {
            uint16_t addr = get_address();
            if(decode_mem(addr)) {
                uint8_t data = mem_read(addr);
                //printf("rd a: 0x%04x d: 0x%02x\n", addr, data);
                set_data(data);
                top->SIM_OE = 0;
            }
        } 
        if(mread_rise) {
            top->SIM_OE = 1;
        }

        static int prev_mwrite = 1;
        int mwrite_fall = 0;

        if(prev_mwrite == 1 && top->MWRITE == 0) {
            mwrite_fall = 1;
        }

        prev_mwrite = top->MWRITE;

        if(mwrite_fall == 1) {
            uint16_t addr = get_address();
            if(decode_mem(addr)) {
                uint8_t data = get_data();
                mem_write(addr, data);
                //printf("wr a: 0x%04x d: 0x%02x\n", addr, data);
            }
        }

        //printf("Addr: 0x%04X\n", SIM_A);
        top->CLOCK = tick_n & 0x01;
        eval_dump();
        main_time_ps += half_period_ps;
        tick_n++;
        top->CLOCK = tick_n & 0x01; 
        eval_dump();
        main_time_ps += half_period_ps;
        tick_n++;
    };

    auto run_n_cycles = [&](vluint64_t n){
        for (vluint64_t i=0;i<n;i++){
            tick();
        }
    };

    auto run_forever = [&](){
        while(!stop_flag.load()) {
            tick();
        }
    };

    const int rst_active   = cfg.rst_active_low ? 0 : 1;
    const int rst_inactive = cfg.rst_active_low ? 1 : 0;

    // Init
    top->CLOCK = 0;           // rename if not CLOCK
    top->RESET = rst_active;  // rename if not RESET

		    

    eval_dump();

    // t1: hold reset

    size_t ticks_before = tick_n;
    auto calib_time_start = std::chrono::steady_clock::now();

    for(size_t i = 0; i<100000; i++) {
        top->CLOCK = tick_n & 0x01;
        eval_dump();
        main_time_ps += half_period_ps;
        tick_n++;
        top->CLOCK = tick_n & 0x01;
        eval_dump();
        main_time_ps += half_period_ps;
        tick_n++;
    }


    size_t ticks_after = tick_n;
    auto calib_time_end = std::chrono::steady_clock::now();


    std::chrono::duration<double> diff = calib_time_end - calib_time_start;
    double calib_freq_mhz = (static_cast<double>(ticks_after - ticks_before) / diff.count()) / 1000000.0;
    printf("\n\nMain clock freq %f MHz\n", calib_freq_mhz);



    auto n_reset_cycles = (ns_to_ps(cfg.t1_reset_low_ns) + half_period_ps - 1) / half_period_ps;
    run_n_cycles(n_reset_cycles);


    // release
    top->RESET = rst_inactive; eval_dump();


    ticks_before = tick_n;
    calib_time_start = std::chrono::steady_clock::now();
    // t2: run
    run_forever();
    ticks_after = tick_n;
    calib_time_end = std::chrono::steady_clock::now();
    
    diff = calib_time_end - calib_time_start;
    calib_freq_mhz = (static_cast<double>(ticks_after - ticks_before) / diff.count()) / 1000000.0;
    printf("\n\nMain clock freq %f MHz\n", calib_freq_mhz);
    
    
    top->final();
#if VSIM_TRACE      
    tfp->close();
    delete tfp;
    std::cout << "[verilator-tb] Wrote VCD to " << cfg.vcd_path << std::endl;
#endif
    delete top;

    std::cout << "Exiting gracefully\n";
    return 0;
}
