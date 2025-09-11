
// 7432 (Quad 2-input OR), Z/X-safe via casez
module ttl_7432 #(
    parameter BLOCKS = 4, parameter WIDTH_IN = 2,
    parameter DELAY_RISE = 0, parameter DELAY_FALL = 0
)(
    input  [BLOCKS*WIDTH_IN-1:0] A_2D,
    output [BLOCKS-1:0]          Y
);
/*verilator inline_module*/
    wire [WIDTH_IN-1:0] A [0:BLOCKS-1];
    reg  [BLOCKS-1:0]   computed;
    integer i;

`ifdef ASSIGN_UNPACK_ARRAY
    `ASSIGN_UNPACK_ARRAY(BLOCKS, WIDTH_IN, A, A_2D)
`else
    genvar gi;
    generate for (gi=0; gi<BLOCKS; gi=gi+1) begin : unpack
        assign A[gi] = A_2D[gi*WIDTH_IN +: WIDTH_IN];
    end endgenerate
`endif

    always @* begin
        for (i=0;i<BLOCKS;i=i+1) begin
            // 00 -> 0; anything else (01/10/11/Z/X) -> 1
            casez (A[i])
                {WIDTH_IN{1'b0}}: computed[i] = 1'b0;
                default:          computed[i] = 1'b1;
            endcase
        end
    end

    assign Y = computed;
endmodule
