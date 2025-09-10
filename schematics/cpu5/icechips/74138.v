
// 74138 (3-to-8 decoder, active-LOW outputs)
module ttl_74138 #(
    parameter WIDTH_OUT = 8,
    parameter WIDTH_IN  = $clog2(WIDTH_OUT),
    parameter DELAY_RISE = 0, parameter DELAY_FALL = 0
)(
    input  Enable1_bar,
    input  Enable2_bar,
    input  Enable3,
    input  [WIDTH_IN-1:0] A,
    output [WIDTH_OUT-1:0] Y
);
    reg [WIDTH_OUT-1:0] computed;
    integer i;

    always @* begin
        // default: all outputs inactive-high
        computed = {WIDTH_OUT{1'b1}};
        if (!Enable1_bar && !Enable2_bar && Enable3) begin
            // choose one line to go LOW
            // guard in case A is bigger than range
            computed[A] = 1'b0;
        end
    end

    assign Y = computed;
endmodule
