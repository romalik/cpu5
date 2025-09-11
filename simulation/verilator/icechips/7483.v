module ttl_7483 #(
    parameter integer WIDTH = 4,
    parameter integer DELAY_RISE = 0, parameter integer DELAY_FALL = 0
)(
    input  [WIDTH-1:0] A, B,
    input  C0,
    output [WIDTH-1:0] S,
    output C4
);
/*verilator inline_module*/
    wire [WIDTH:0] C0_wide = {{WIDTH{1'b0}}, C0};
    
    wire [WIDTH:0] tmp = {1'b0, A} + {1'b0, B} + C0_wide;
    assign  S  = tmp[WIDTH-1:0];
    assign  C4 = tmp[WIDTH];
endmodule
