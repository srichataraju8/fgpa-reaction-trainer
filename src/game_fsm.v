module game_fsm (
    input wire clk,             // Clock signal
    input wire rst,             // Reset signal
    input wire start_btn,       // Clean start input
    input wire stop_btn,        // Clean reaction input
    input wire [15:0] rand_val, // Input seed for varying delay intervals
    output reg [1:0] state,     // Current operational state indicator
    output reg timer_en,        // High-level enable for millisecond counter
    output reg stimulus_led     // Prompt signal for user to click button
);

    localparam STATE_IDLE    = 2'b00;
    localparam STATE_DELAY   = 2'b01;
    localparam STATE_TRIGGER = 2'b10;
    localparam STATE_RESULTS = 2'b11;

    reg [31:0] delay_counter = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_IDLE;
            timer_en <= 0;
            stimulus_led <= 0;
            delay_counter <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    timer_en <= 0;
                    stimulus_led <= 0;
                    delay_counter <= 0;
                    if (start_btn) state <= STATE_DELAY;
                end

                STATE_DELAY: begin
                    timer_en <= 0;
                    stimulus_led <= 0;
                    if (delay_counter >= (32'd100000000 + {16'b0, rand_val} * 32'd1000)) begin
                        state <= STATE_TRIGGER;
                        delay_counter <= 0;
                    end else begin
                        delay_counter <= delay_counter + 1;
                    end
                end

                STATE_TRIGGER: begin
                    timer_en <= 1;       
                    stimulus_led <= 1;   
                    if (stop_btn) begin
                        state <= STATE_RESULTS;
                    end
                end

                STATE_RESULTS: begin
                    timer_en <= 0;       
                    stimulus_led <= 0;
                    if (rst) state <= STATE_IDLE;
                end
                
                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule
