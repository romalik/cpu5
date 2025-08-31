module ttl_74193 #(
    parameter integer WIDTH      = 4,
    parameter integer DELAY_RISE = 0,
    parameter integer DELAY_FALL = 0
)(
    input                   CPU,      // Count-UP clock (rising edge)
    input                   CPD,      // Count-DOWN clock (rising edge)
    input                   MR,       // Async Master Reset (active high)
    input                   PL_bar,   // Async Parallel Load (active low)
    input      [WIDTH-1:0]  D,        // Parallel load data
    output     [WIDTH-1:0]  Q,        // Counter outputs
    output                  TCU_bar,  // Active-low carry (terminal COUNT UP)
    output                  TCD_bar   // Active-low borrow (terminal COUNT DOWN)
);

    // Internal state register
    // (Multiple always blocks drive q_r intentionally to model dual clocks + async controls.)
// verilator lint_off MULTIDRIVEN
    reg [WIDTH-1:0] q_r = 4'b1;
// verilator lint_on  MULTIDRIVEN

    // Asynchronous controls: MR (active high) and PL_bar (active low)
    // Either one takes immediate effect, independent of CPU/CPD.
    always @(posedge MR or negedge PL_bar) begin
        if (MR)          q_r <= {WIDTH{1'b0}};  // async clear
        else             q_r <= D;              // async parallel load
    end

    // UP clock: count on rising edge of CPU when not under async control
    always @(posedge CPU) begin
        if (!MR && PL_bar) begin
            q_r <= q_r + {{(WIDTH-1){1'b0}}, 1'b1};
        end
    end

    // DOWN clock: count on rising edge of CPD when not under async control
    always @(posedge CPD) begin
        if (!MR && PL_bar) begin
            q_r <= q_r - {{(WIDTH-1){1'b0}}, 1'b1};
        end
    end

    // Output pins with (optional) rise/fall delays
    assign #(DELAY_RISE, DELAY_FALL) Q = q_r;

    // Terminal count outputs (active-low pulses for cascading)
    // TCU_bar goes LOW when counting up from all-ones (i.e., Q==max) with CPU high.
    // TCD_bar goes LOW when counting down from zero (i.e., Q==0) with CPD high.
    // This matches the classic 74193 "ripple" cascade behavior.
    wire tcu_n = ~(~CPU & (&q_r));      // all bits 1
    wire tcd_n = ~(~CPD & (~|q_r));     // all bits 0

    assign #(DELAY_RISE, DELAY_FALL) TCU_bar = tcu_n;
    assign #(DELAY_RISE, DELAY_FALL) TCD_bar = tcd_n;

endmodule
