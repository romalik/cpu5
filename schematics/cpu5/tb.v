`timescale 1ns/1ps
`default_nettype none

module tb;
    // ----- Drivers we control (procedural) -----
    reg CLOCK_drv = 0;
    reg RESET_drv = 1;  // active-HIGH reset (Clear_bar)

    // ----- Wires that connect to DUT inout ports -----
    wire CLOCK;
    wire RESET;

    // Drive the inout nets from our regs
    assign CLOCK = CLOCK_drv;
    assign RESET = RESET_drv;

    // DUT outputs (also 'inout' in cpu5.v, but we only observe them)
    wire phase_mread, phase_write, cword_en, p3;
    wire mpc0, mpc1, mpc2, mpc3;

    // DUT from KiCadVerilog (cpu5.v). DO NOT EDIT cpu5.v BY HAND.
    cpu5 DUT (
        .CLOCK(CLOCK),
        .RESET(RESET),
        .phase_mread(phase_mread), .phase_write(phase_write), .cword_en(cword_en), .p3(p3),
        .mpc0(mpc0), .mpc1(mpc1), .mpc2(mpc2), .mpc3(mpc3)
    );

    // Clock generator (100 MHz, 10 ns period)
    always #5 CLOCK_drv = ~CLOCK_drv;

    initial begin
        $dumpfile("cpu5.vcd");
        $dumpvars(0, tb);

        // Hold async reset low, then release
        RESET_drv = 1; #37;
        RESET_drv = 0;            // release → counter starts ticking on next rising edge(s)
        #5000;

        // Prove async reset mid-run
        RESET_drv = 1; #20; RESET_drv = 0; #3000;

        $finish;
    end
endmodule

`default_nettype wire
