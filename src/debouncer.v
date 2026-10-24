module debouncer (
    input wire clk,       // 100 MHz Master System Clock
    input wire async_in,  // Raw noisy button input from board
    output reg sync_out   // Clean filtered synchronized output
);

    reg [19:0] counter = 0;
    reg step1 = 0;
    reg step2 = 0;

    always @(posedge clk) begin
        // Two-stage shift register to eliminate metastability challenges
        step1 <= async_in;
        step2 <= step1;
        
        // Check if input matches output, otherwise iterate stability timer
        if (step2 == sync_out) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 20'hF4240) begin // ~10ms validation threshold window at 100MHz
                sync_out <= step2;
                counter <= 0;
            end
        end
    end
endmodule
