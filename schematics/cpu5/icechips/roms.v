// 8Kx8 AT28C64-ish ROM, Verilog-2001 compatible
module at28c64_rom #(
    parameter integer ROM_INDEX = 0   // set from KiCad symbol
)(
    input  [12:0] A,
    inout  [7:0]  D,
    input         nCE,
    input         nOE,
    input         nWE
);
    reg [7:0] mem [0:8191];

    // Tristate read
    wire enable = ~nCE & ~nOE;
    assign D = enable ? mem[A] : 8'bz;

    // ===== ELABORATION-TIME SELECTION OF THE FILE =====
    generate
        if (ROM_INDEX == 0) begin : g0
            initial $readmemh("microcode_0.bin.vhex", mem);
        end else
        if (ROM_INDEX == 1) begin : g1
            initial $readmemh("microcode_1.bin.vhex", mem);
        end else
        if (ROM_INDEX == 2) begin : g2
            initial $readmemh("alu_low.bin.vhex", mem);
        end else
        if (ROM_INDEX == 3) begin : g3
            initial $readmemh("alu_high.bin.vhex", mem);
        end else begin : g_bad
            initial begin
                $display("FATAL: Unsupported ROM_INDEX=%0d for at28c64_rom", ROM_INDEX);
                $finish;
            end
        end
    endgenerate

endmodule
