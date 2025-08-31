
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
    double t1_reset_low_ns = 37.0;
    double t2_run_ns       = 500000.0;
    double t3_reset_low_ns = 20.0;
    double t4_run_ns       = 300000.0;
    bool   rst_active_low  = true;
    std::string vcd_path   = "cpu5.vcd";
};

static void parse_cli(int argc, char** argv, SimCfg& cfg) {
    for (int i=1;i<argc;i++) {
        std::string a(argv[i]);
        auto eat = [&](double &dst){
            if (i+1>=argc) { std::cerr<<"Missing value after "<<a<<"\n"; std::exit(2); }
            dst = std::atof(argv[++i]);
        };
        if (a=="--period-ns") eat(cfg.period_ns);
        else if (a=="--t1-reset-low-ns") eat(cfg.t1_reset_low_ns);
        else if (a=="--t2-run-ns") eat(cfg.t2_run_ns);
        else if (a=="--t3-reset-low-ns") eat(cfg.t3_reset_low_ns);
        else if (a=="--t4-run-ns") eat(cfg.t4_run_ns);
        else if (a=="--rst-active-low") { if (i+1>=argc) { std::cerr<<"Missing value\n"; std::exit(2);} cfg.rst_active_low = std::atoi(argv[++i])!=0; }
        else if (a=="--vcd") { if (i+1>=argc) { std::cerr<<"Missing value\n"; std::exit(2);} cfg.vcd_path = argv[++i]; }
        else if (a=="--help" || a=="-h") {
            std::cout << "Usage: " << argv[0] << " [options]\n"
                      << "  --period-ns <f>\n"
                      << "  --t1-reset-low-ns <f>\n"
                      << "  --t2-run-ns <f>\n"
                      << "  --t3-reset-low-ns <f>\n"
                      << "  --t4-run-ns <f>\n"
                      << "  --rst-active-low 0|1\n"
                      << "  --vcd <path>\n";
            std::exit(0);
        }
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    SimCfg cfg;
    parse_cli(argc, argv, cfg);

    const vluint64_t half_period_ps = ns_to_ps(cfg.period_ns) / 2;

    Top* top = new Top;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open(cfg.vcd_path.c_str());

    auto eval_dump = [&](){
        top->eval();
        tfp->dump(main_time_ps);
    };

    auto tick_half = [&](int clk_val){
        top->CLOCK = clk_val ? 1 : 0; // rename if not CLOCK
    top->iDATA0 = 1; //nop
    top->iDATA1 = 1; //nop
    top->iDATA2 = 0; //nop
    top->iDATA3 = 0; //nop
    top->iDATA4 = 0; //nop
    top->iDATA5 = 0; //nop
    top->iDATA6 = 0; //nop
    top->iDATA7 = 0; //nop
        eval_dump();
        main_time_ps += half_period_ps;
    };

    auto run_half_cycles = [&](vluint64_t halves){
        for (vluint64_t i=0;i<halves;i++){
            tick_half(i & 1); // 0,1,0,1,...
        }
    };

    const int rst_active   = cfg.rst_active_low ? 0 : 1;
    const int rst_inactive = cfg.rst_active_low ? 1 : 0;

    // Init
    top->CLOCK = 0;           // rename if not CLOCK
    top->RESET = rst_active;  // rename if not RESET

		    

    eval_dump();

    // t1: hold reset
    auto halves = (ns_to_ps(cfg.t1_reset_low_ns) + half_period_ps - 1) / half_period_ps;
    run_half_cycles(halves);

    // release
    top->RESET = rst_inactive; eval_dump();

    // t2: run
    halves = (ns_to_ps(cfg.t2_run_ns) + half_period_ps - 1) / half_period_ps;
    run_half_cycles(halves);

    // t3: reset pulse
    top->RESET = rst_active; eval_dump();
    halves = (ns_to_ps(cfg.t3_reset_low_ns) + half_period_ps - 1) / half_period_ps;
    run_half_cycles(halves);

    // t4: final run
    top->RESET = rst_inactive; eval_dump();
    halves = (ns_to_ps(cfg.t4_run_ns) + half_period_ps - 1) / half_period_ps;
    run_half_cycles(halves);

    top->final();
    tfp->close();
    delete tfp;
    delete top;

    std::cout << "[verilator-tb] Wrote VCD to " << cfg.vcd_path << std::endl;
    return 0;
}
