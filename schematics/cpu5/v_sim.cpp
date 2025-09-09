
// tb_like_verilator.cpp
// Minimal C++ testbench using Verilator, mirroring a tb.v timeline and dumping VCD.
//
// Defaults:
//  - Top module: cpu5  (change include/class below if different)
//  - Ports: CLOCK (clock), RESET (reset, active-LOW by default)
//  - Clock period: 10 ns
//  - Sequence: RESET low 37 ns, run 5000 ns, RESET low 20 ns, run 3000 ns
//
// Build (A: one-shot):
//   verilator -cc cpu5.v --exe /mnt/data/tb_like_verilator.cpp \
//     --trace --timescale-override 1ns/1ps --build -o sim_tb_like
//   ./sim_tb_like
//
// Build (B: many files / include dirs):
//   verilator -cc /path/cpu5.v /path/helper.v -I$ICECHIPS_DIR \
//     --exe /mnt/data/tb_like_verilator.cpp --trace \
//     --timescale-override 1ns/1ps --build -o sim_tb_like
//
// Using the Makefile:
//   make -f /mnt/data/Makefile.verilator_tb \
//        TOP=cpu5 \
//        VSRCS="/path/cpu5.v /path/helper.v" \
//        INCLUDES="-I$(ICECHIPS_DIR)" \
//        OUT=sim_tb_like
//
// VCD output: cpu5_tb_like.vcd (open with: gtkwave cpu5_tb_like.vcd)
//
// CLI options:
//   --period-ns <float>
//   --t1-reset-low-ns <float>  (default 37)
//   --t2-run-ns <float>        (default 5000)
//   --t3-reset-low-ns <float>  (default 20)
//   --t4-run-ns <float>        (default 3000)
//   --rst-active-low 0|1       (default 1)
//   --vcd <path>
//
// NOTE: If your top module isn't 'cpu5', change the include ("Vcpu5.h") and class (Vcpu5) below.

#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
#include <csignal>
#include <atomic>
#include <thread>
#include <vector>
#include <mutex>
#include <unistd.h>
#include <fcntl.h>
#include <cerrno>
#include <cstdio>
#include <cstring>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <cerrno>
#include <cstring>
#include <queue>


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





class keyboard{
    public:
        keyboard();
        ~keyboard();
        int pop();
        int has_data();
    private:
        int kbhit();
        int getch();
        struct termios initial_settings, new_settings;
        int peek_character;
        std::thread thr;
        void runner();
        bool running;
        std::queue<int> q;
        size_t max_q{64};
        std::mutex mtx;
        std::atomic<bool> has_data_atomic{false};

};
    
int keyboard::pop() {
    std::lock_guard<std::mutex> lock(mtx);
    if(!q.empty()) {
        int c = q.front();
        q.pop();
        if(q.empty()) {
            has_data_atomic.store(false);
        }
        return c;
    }
    return 0;
}
int keyboard::has_data() {
    return has_data_atomic.load();
}
        
keyboard::keyboard(){
    tcgetattr(0,&initial_settings);
    new_settings = initial_settings;
    new_settings.c_lflag &= ~ICANON;
    new_settings.c_lflag &= ~ECHO;
    new_settings.c_cc[VMIN] = 1;
    new_settings.c_cc[VTIME] = 0;
    tcsetattr(0, TCSANOW, &new_settings);
    peek_character=-1;
    running = true;
    thr = std::thread(&keyboard::runner, this);
}
    
keyboard::~keyboard(){
    tcsetattr(0, TCSANOW, &initial_settings);
    running = false;
    thr.join();
}

void keyboard::runner() {
    while(running) {
        if(kbhit()) {
            int c = getch();
            if(q.size() < max_q) {
                std::lock_guard<std::mutex> lock(mtx);
                q.push(c);
                has_data_atomic.store(true);
            }
        }
        usleep(5*1000);
    }
}

int keyboard::kbhit(){
    unsigned char ch;
    int nread;
    if (peek_character != -1) return 1;
    new_settings.c_cc[VMIN]=0;
    tcsetattr(0, TCSANOW, &new_settings);
    nread = read(0,&ch,1);
    new_settings.c_cc[VMIN]=1;
    tcsetattr(0, TCSANOW, &new_settings);

    if (nread == 1){
        peek_character = ch;
        return 1;
    }
    return 0;
}
    
int keyboard::getch(){
    char ch;

    if (peek_character != -1){
        ch = peek_character;
        peek_character = -1;
    }
    else read(0,&ch,1);
    return ch;
}


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

void read_file(const char *filename, std::vector<uint8_t> & data) {
    FILE *f = fopen(filename, "rb");
    if (!f) {
        perror("fopen");
    }

    if (fseek(f, 0, SEEK_END) != 0) {
        perror("fseek");
        fclose(f);
    }

    long size = ftell(f);
    if (size < 0) {
        perror("ftell");
        fclose(f);
    }
    rewind(f);

    data.resize(size);

    unsigned char *buffer = data.data();


    size_t read = fread(buffer, 1, size, f);
    if (read != (size_t)size) {
        fprintf(stderr, "fread failed (read %zu of %ld)\n", read, size);
        fclose(f);
    }

    fclose(f);
}


class SimpleStorage {
public:
    SimpleStorage() {};
    void load(std::string path) {
        printf("Loading HDD %s...\n", path.c_str());
        read_file(path.c_str(), data);
        printf("Loaded HDD %s of size %zu\n", path.c_str(), data.size());
    }

    void init(size_t sz) {
        data.clear();
        data.resize(sz);
    }

    void set_high_addr(uint8_t addr) {
        c_high = addr;        
        c_idx = 0;
    }
    void set_mid_addr(uint8_t addr) {
        c_mid = addr;
        c_idx = 0;
    }
    void set_low_addr(uint8_t addr) {
        c_low = addr;
        c_idx = 0;
    }
    uint8_t read() {
        uint8_t d = data[full_addr()];
        c_idx++;
        return d;
    }

    void write(uint8_t d) {
        data[full_addr()] = d;
        c_idx++;
    }

private:
    size_t full_addr() {
        return c_idx | (c_mid << 8) | (c_high << 16);
    }

    std::vector<uint8_t> data;
    uint8_t c_high{0};
    uint8_t c_mid{0};
    uint8_t c_low{0};
    uint8_t c_idx{0};
    

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
};

Args parse_args(int argc, char* argv[]) {
    Args args;
    for (int i = 1; i < argc; ++i) {
        std::string key = argv[i];
        if ((key == "--rom") && i + 1 < argc) {
            args.rom = argv[++i]; // eat next arg
        } else if ((key == "--hdd") && i + 1 < argc) {
            args.hdd = argv[++i];
        }
    }
    return args;
}



int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);


    std::signal(SIGINT, sigint_handler);
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
        top->CLOCK = tick_n & 0x01; // rename if not CLOCK
        eval_dump();
        main_time_ps += half_period_ps;
        tick_n++;
        top->CLOCK = tick_n & 0x01; // rename if not CLOCK
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


    auto n_reset_cycles = (ns_to_ps(cfg.t1_reset_low_ns) + half_period_ps - 1) / half_period_ps;
    run_n_cycles(n_reset_cycles);


    // release
    top->RESET = rst_inactive; eval_dump();



    size_t ticks_before = tick_n;
    auto calib_time_start = std::chrono::steady_clock::now();

    // t2: run
    run_forever();

    size_t ticks_after = tick_n;
    auto calib_time_end = std::chrono::steady_clock::now();


    std::chrono::duration<double> diff = calib_time_end - calib_time_start;
    double calib_freq_mhz = (static_cast<double>(ticks_after - ticks_before) / diff.count()) / 1000000.0;
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
