module seven_seg_mux (
    input wire clk,               // 100 MHz Master System Clock
    input wire rst,               // Synchronous system reset
    input wire [3:0] thousands,   // BCD input for thousands place
    input wire [3:0] hundreds,    // BCD input for hundreds place
    input wire [3:0] tens,        // BCD input for tens place
    input wire [3:0] units,       // BCD input for units place
    output reg [3:0] anodes,      // 4-bit common anode digit enable signals
    output reg [6:0] cathodes     // 7-bit active-low segment controls (A-G)
);

    reg [16:0] refresh_counter = 0;
    reg [1:0] active_digit = 0;
    reg [3:0] current_bcd = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 0;
            active_digit <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            active_digit <= refresh_counter[16:15];
        end
    end

    always @(*) begin
        case (active_digit)
            2'b00: begin anodes = 4'b1110; current_bcd = units;     end
            2'b01: begin anodes = 4'b1101; current_bcd = tens;      end
            2'b10: begin anodes = 4'b1011; current_bcd = hundreds;  end
            2'b11: begin anodes = 4'b0111; current_bcd = thousands; end
            default: begin anodes = 4'b1111; current_bcd = 4'b0000; end
        endcase
    end

    always @(*) begin
        case (current_bcd)
            4'h0: cathodes = 7'b1000000; // "0"
            4'h1: cathodes = 7'b1111001; // "1"
            4'h2: cathodes = 7'b0100100; // "2"
            4'h3: cathodes = 7'b0110000; // "3"
            4'h4: cathodes = 7'b0011001; // "4"
            4'h5: cathodes = 7'b0010010; // "5"
            4'h6: cathodes = 7'b0000010; // "6"
            4'h7: cathodes = 7'b1111000; // "7"
            4'h8: cathodes = 7'b0000000; // "8"
            4'h9: cathodes = 7'b0010000; // "9"
            default: cathodes = 7'b1111111; 
        endcase
    end
endmodule
