`timescale 1ns/1ps
`default_nettype none

module tb;
    // ----- Drivers we control (procedural) -----
    reg CLOCK_drv = 0;
    reg RESET_drv = 0;  // active-LOW reset (Clear_bar)

    // ----- Wires that connect to DUT inout ports -----
    wire CLOCK;
    wire RESET;

    // Drive the inout nets from our regs
    assign CLOCK = CLOCK_drv;
    assign RESET = RESET_drv;

    // DUT outputs (also 'inout' in cpu5.v, but we only observe them)
    wire phase_mread, phase_write, cword_en, p3;
    wire mpc0, mpc1, mpc2, mpc3;
    wire iDATA0, iDATA1, iDATA2, iDATA3, iDATA4, iDATA5, iDATA6, iDATA7;

    // DUT from KiCadVerilog (cpu5.v). DO NOT EDIT cpu5.v BY HAND.
    cpu5 DUT (
        .CLOCK(CLOCK),
        .RESET(RESET),
        .phase_mread(phase_mread), .phase_write(phase_write), .cword_en(cword_en), .p3(p3),
        .mpc0(mpc0), .mpc1(mpc1), .mpc2(mpc2), .mpc3(mpc3),
	.iDATA0(iDATA0), .iDATA1(iDATA1), .iDATA2(iDATA2), .iDATA3(iDATA3), .iDATA4(iDATA4), .iDATA5(iDATA5), .iDATA6(iDATA6), .iDATA7(iDATA7)
    );

    pullup(iDATA0);
    pullup(iDATA1);
    pulldown(iDATA2);
    pulldown(iDATA3);
    pulldown(iDATA4);
    pulldown(iDATA5);
    pulldown(iDATA6);
    pulldown(iDATA7);



    // Clock generator (100 MHz, 10 ns period)
    always #5 CLOCK_drv = ~CLOCK_drv;

    initial begin
        $dumpfile("cpu5.vcd");
        $dumpvars(0, tb);

        // Hold async reset low, then release
        RESET_drv = 0; #400;
        RESET_drv = 1;            // release → counter starts ticking on next rising edge(s)
        #500000;

        // Prove async reset mid-run
        RESET_drv = 0; #20; RESET_drv = 1; #300000;

        $finish;
    end
endmodule

`default_nettype wire
