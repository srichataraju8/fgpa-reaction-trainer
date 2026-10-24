module counter_ms (
    input wire clk,              // 100 MHz Master System Clock
    input wire rst,              // Master system clear 
    input wire timer_en,         // Operational enable flag from FSM
    output reg [3:0] thousands,  // Output BCD values 
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] units
);

    reg [31:0] tick_counter = 0;
    wire ms_tick;

    assign ms_tick = (tick_counter == 32'd100000);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tick_counter <= 0;
        end else if (timer_en) begin
            if (ms_tick)
                tick_counter <= 0;
            else
                tick_counter <= tick_counter + 1;
        end else begin
            tick_counter <= 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            units     <= 4'b0000;
            tens      <= 4'b0000;
            hundreds  <= 4'b0000;
            thousands <= 4'b0000;
        end else if (timer_en && ms_tick) begin
            if (units == 4'd9) begin
                units <= 4'd0;
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        if (thousands == 4'd9) begin
                            thousands <= 4'd0; 
                        end else begin
                            thousands <= thousands + 1;
                        end
                    end else begin
                        hundreds <= hundreds + 1;
                    end
                end else begin
                    tens <= tens + 1;
                end
            end else begin
                units <= units + 1;
            end
        end
    end
endmodule
