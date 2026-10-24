module reaction_trainer_top (
    input wire clk,             // 100 MHz Master System Clock from Basys 3
    input wire btnR,            // Master Reset input button
    input wire btnC,            // Game Start input button
    input wire btnU,            // User Reaction input button
    output wire [15:0] led,     // Onboard LED array indicator array
    output wire [3:0] an,       // Common anode controls for display digits
    output wire [6:0] seg       // Active-low segment drivers (A-G)
);

    wire rst_clean;
    wire start_clean;
    wire stop_clean;
    wire timer_enable;
    wire stimulus;
    
    wire [3:0] bcd_thousands;
    wire [3:0] bcd_hundreds;
    wire [3:0] bcd_tens;
    wire [3:0] bcd_units;

    debouncer debounce_reset (
        .clk(clk),
        .async_in(btnR),
        .sync_out(rst_clean)
    );

    debouncer debounce_start (
        .clk(clk),
        .async_in(btnC),
        .sync_out(start_clean)
    );

    debouncer debounce_stop (
        .clk(clk),
        .async_in(btnU),
        .sync_out(stop_clean)
    );

    game_fsm controller_fsm (
        .clk(clk),
        .rst(rst_clean),
        .start_btn(start_clean),
        .stop_btn(stop_clean),
        .rand_val(16'hA3F0), 
        .state(),            
        .timer_en(timer_enable),
        .stimulus_led(stimulus)
    );

    assign led = {16{stimulus}};

    counter_ms primary_counter (
        .clk(clk),
        .rst(rst_clean),
        .timer_en(timer_enable),
        .thousands(bcd_thousands),
        .hundreds(bcd_hundreds),
        .tens(bcd_tens),
        .units(bcd_units)
    );

    seven_seg_mux display_driver (
        .clk(clk),
        .rst(rst_clean),
        .thousands(bcd_thousands),
        .hundreds(bcd_hundreds),
        .tens(bcd_tens),
        .units(bcd_units),
        .anodes(an),
        .cathodes(seg)
    );

endmodule
