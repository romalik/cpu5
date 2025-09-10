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
  import "DPI-C" function byte verilator_mem_read (int addr, int mem_idx);
  import "DPI-C" function void verilator_mem_write (int addr, byte data, int mem_idx);
    //reg [7:0] mem [0:8191];

    // Tristate read
    wire enable = ~nCE & ~nOE;
    assign D = enable ? verilator_mem_read(A, ROM_INDEX) : 8'bz;

    wire [7:0] din = D; // read the bus value driven by host
    always @(negedge nWE) begin
        if (~nCE) begin
            verilator_mem_write(A, din, ROM_INDEX);
        end
    end




endmodule

// 32Kx8 AT28C256-ish ROM, Verilog-2001 compatible
module at28c256_rom #(
    parameter integer ROM_INDEX = -1   // set from KiCad symbol
)(
    input  [14:0] A,
    inout  [7:0]  D,
    input         nCE,
    input         nOE,
    input         nWE
);
    //reg [7:0] mem [0:32767];
  import "DPI-C" function byte verilator_mem_read (int addr, int mem_idx);
  import "DPI-C" function void verilator_mem_write (int addr, byte data, int mem_idx);

    // Tristate read
    wire enable = ~nCE & ~nOE;
    assign D = enable ? verilator_mem_read(A, ROM_INDEX) : 8'bz;


    wire [7:0] din = D; // read the bus value driven by host
    always @(negedge nWE) begin
        if (~nCE) begin
            verilator_mem_write(A, din, ROM_INDEX);
        end
    end

endmodule


// 512Kx8 RAM, Verilog-2001 compatible
module ram_512 #(
    parameter integer ROM_INDEX = -1   // set from KiCad symbol
)(
    input  [18:0] A,
    inout  [7:0]  D,
    input         nCE,
    input         nOE,
    input         nWE
);

  import "DPI-C" function byte verilator_mem_read (int addr, int mem_idx);
  import "DPI-C" function void verilator_mem_write (int addr, byte data, int mem_idx);

    //reg [7:0] mem [0:524287];

    // Tristate read
    wire enable = ~nCE & ~nOE;
    //assign D = enable ? mem[A] : 8'bz;
    assign D = enable ? verilator_mem_read(A, ROM_INDEX) : 8'bz;


    wire [7:0] din = D; // read the bus value driven by host
    always @(negedge nWE) begin
        if (~nCE) begin
            verilator_mem_write(A, din, ROM_INDEX);
        end
    end
endmodule

