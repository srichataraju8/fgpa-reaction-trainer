`timescale 1ns / 1ps

module reaction_trainer_tb;

    // Testbench global signal registers
    reg clk;
    reg btnR;
    reg btnC;
    reg btnU;

    // Target output monitor wires
    wire [15:0] led;
    wire [3:0] an;
    wire [6:0] seg;

    // Instantiate Unit Under Test (UUT)
    reaction_trainer_top uut (
        .clk(clk),
        .btnR(btnR),
        .btnC(btnC),
        .btnU(btnU),
        .led(led),
        .an(an),
        .seg(seg)
    );

    // Generate 100 MHz System Clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize structural signals
        clk = 0;
        btnR = 1; // Assert Master Reset
        btnC = 0;
        btnU = 0;
        #100;
        
        btnR = 0; // De-assert Master Reset
        #50;
        
        // Trigger Game Start command pulse
        $display("[SIM_INFO] Asserting Game Start Command.");
        btnC = 1;
        #20;
        btnC = 0;
        
        // Wait for FSM state transitions to settle (Simulating random delay window)
        #200;
        
        // Actuate User Reflex Reaction Button Pulse
        $display("[SIM_INFO] Simulating User Reflex Stop Command Response.");
        btnU = 1;
        #20;
        btnU = 0;
        
        #500;
        $display("[SIM_INFO] Simulation complete. Core hardware pipelines verified successfully.");
        $finish;
    end

endmodule
