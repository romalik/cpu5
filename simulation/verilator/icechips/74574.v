
// 74574 (Octal D FF with tri-state outputs, OE_bar active-low)
module ttl_74574 #(
    parameter WIDTH = 8,
    parameter DELAY_RISE = 0, parameter DELAY_FALL = 0
)(
    input  CLK,
    input  OE_bar,
    input  [WIDTH-1:0] D,
    output [WIDTH-1:0] Y
);
/*verilator inline_module*/
    reg [WIDTH-1:0] q;
    always @(posedge CLK) begin
        q <= D;
    end

    // Tri-state outputs (Verilator supports Z on nets; if you want no-Z modeling, gate externally)
    assign Y = (OE_bar == 1'b0) ? q : {WIDTH{1'bz}};
endmodule
