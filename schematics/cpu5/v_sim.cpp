
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

#include "verilated.h"
#include "verilated_vcd_c.h"

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


int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    SimCfg cfg;

    size_t tick_n = 0;

    const vluint64_t half_period_ps = ns_to_ps(cfg.period_ns) / 2;

    Top* top = new Top;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open(cfg.vcd_path.c_str());

    top->SIM_OE = 1;

    std::vector<uint8_t> mem(65535);

    mem[0] = 0x03; //nop
    mem[1] = 0x03; //nop
    mem[2] = 0x03; //nop

    mem[3] = 0xde; //ldd X
    mem[4] = 0x02;
    mem[5] = 0x00; // 0x0001
    
    mem[6] = 0xaf; //jmp

    auto eval_dump = [&](){
        top->eval();
        tfp->dump(main_time_ps);
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

        if(top->MREAD == 0) {
            uint16_t addr = get_address();
            uint8_t data = mem[addr];
            printf("a: 0x%04x d: 0x%02x\n", addr, data);
            set_data(data);
            top->SIM_OE = 0;
        } else {
            top->SIM_OE = 1;
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

    // t2: run
    auto n_run_cycles = (ns_to_ps(cfg.t2_run_ns) + half_period_ps - 1) / half_period_ps;
    run_n_cycles(n_run_cycles);

    top->final();
    tfp->close();
    delete tfp;
    delete top;

    std::cout << "[verilator-tb] Wrote VCD to " << cfg.vcd_path << std::endl;
    return 0;
}
