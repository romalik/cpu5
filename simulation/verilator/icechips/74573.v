// ttl_74573.v — Octal D latch w/ 3-state outputs (’573 behavior)
// LE (Latch Enable) active-HIGH transparent; OE_bar active-LOW enables outputs.
//
// Usage matches icechips style loosely; adjust names to your symbol.
// If you want internal Q exposed too, split Y/Q as needed.

`timescale 1ns/1ps
module ttl_74573
#(
  parameter WIDTH      = 8,
  parameter DELAY_RISE = 5,
  parameter DELAY_FALL = 3
)
(
  input  wire [WIDTH-1:0] D,       // data in
  input  wire             LE,      // latch enable (HIGH = transparent)
  input  wire             OE_bar,  // output enable (LOW = drive)
  output wire [WIDTH-1:0] Y        // tri-stated outputs
);

  reg [WIDTH-1:0] q;

  // Transparent-high latch
  always @ (D or LE) begin
    if (LE) q <= D;   // hold when LE=0
  end

  // 3-state outputs, active-low OE
  assign #(DELAY_RISE, DELAY_FALL) Y = (~OE_bar) ? q : {WIDTH{1'bz}};

endmodule
