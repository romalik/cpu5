// ttl_74574.v — Octal D flip-flop w/ 3-state outputs (’574 behavior)
// CLK (rising-edge) captures D; OE_bar active-LOW enables outputs.
//
// Mirrors your ttl_74573 style: WIDTH/DELAY_* params, tri-stated Y.
// No async clear (real ’574 doesn’t have it). If you need POR, add external reset gating.
//

`timescale 1ns/1ps
module ttl_74574
#(
  parameter WIDTH      = 8,
  parameter DELAY_RISE = 5,
  parameter DELAY_FALL = 3,
  parameter DEFAULT_PULL = 1'b1
)
(
  input  wire [WIDTH-1:0] D,       // data in
  input  wire             CLK,     // rising-edge clock
  input  wire             OE_bar,  // output enable, active LOW
  output wire [WIDTH-1:0] Y        // tri-stated outputs
);

  reg [WIDTH-1:0] q = 8'b11111111;


  // Vector sanitizer
  function automatic [7:0] sanitize (input [7:0] v);
    integer i;
    for (i = 0; i < 8; i = i + 1)
      sanitize[i] = ((v[i] === 1'bz) ? 1'b1 : v[i]); 
  endfunction


  // Rising-edge capture (edge-triggered FFs)
  always @ (posedge CLK) begin
    q <= sanitize(D);
  end

  // 3-state outputs, active-low OE
  assign #(DELAY_RISE, DELAY_FALL) Y = ((OE_bar == 1'b0) ? q : {WIDTH{1'bz}});

endmodule
