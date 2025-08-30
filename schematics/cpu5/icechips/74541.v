// ttl_74541.v — Octal non-inverting buffer/line driver w/ 3-state outputs (’541 behavior)
// Two active-LOW enables: OE1_bar and OE2_bar. Outputs are driven only when BOTH enables are LOW.
// Matches style of ttl_74573.v (WIDTH/DELAY params, tri-stated Y bus).

`timescale 1ns/1ps
module ttl_74541
#(
  parameter WIDTH      = 8,
  parameter DELAY_RISE = 5,
  parameter DELAY_FALL = 3
)
(
  input  wire [WIDTH-1:0] A,        // data inputs
  input  wire             OE1_bar,  // output enable 1 (active-LOW)
  input  wire             OE2_bar,  // output enable 2 (active-LOW)
  output wire [WIDTH-1:0] Y         // tri-stated outputs
);

  // Outputs enabled only when both enables are LOW.
  wire enable = (~OE1_bar) & (~OE2_bar);

  // 3-state outputs; when disabled, Y is Hi-Z.
  // Use pull-ups/downs externally if you need a defined idle level on the bus.
  assign #(DELAY_RISE, DELAY_FALL) Y = enable ? A : {WIDTH{1'bz}};

endmodule
