module ttl_7474_bit(
    input  D, input Clk, input Preset_bar, input Clear_bar,
    output Q, output Q_bar
);
/*verilator inline_module*/
    reg q = 1'b0;
    always @(posedge Clk or negedge Clear_bar or negedge Preset_bar) begin
      if (!Clear_bar)       q <= 1'b0;
      else if (!Preset_bar) q <= 1'b1;
      else                  q <= D;
    end
    assign Q = q;
    assign Q_bar = ~q;
endmodule

module ttl_7474 #(
    parameter BLOCKS = 2,
    parameter DELAY_RISE = 0, parameter DELAY_FALL = 0
)(
    input  [BLOCKS-1:0] D,
    input  [BLOCKS-1:0] Clk,
    input  [BLOCKS-1:0] Preset_bar,
    input  [BLOCKS-1:0] Clear_bar,
    output [BLOCKS-1:0] Q,
    output [BLOCKS-1:0] Q_bar
);
/*verilator inline_module*/
    genvar i;
    generate
      for (i=0;i<BLOCKS;i=i+1) begin : g
        ttl_7474_bit u(
          .D(D[i]), .Clk(Clk[i]),
          .Preset_bar(Preset_bar[i]), .Clear_bar(Clear_bar[i]),
          .Q(Q[i]), .Q_bar(Q_bar[i])
        );
      end
    endgenerate
endmodule
