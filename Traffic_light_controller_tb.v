`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2025 01:00:51
// Design Name: 
// Module Name: Traffic_light_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Traffic_light_controller_tb;

    reg clk, reset, enable, Sa, Sb;
    wire R_a, Y_a, G_a;
    wire R_b, Y_b, G_b;

    // DUT instantiation with FINAL_VALUE = 500 (5 µs per state)
    Traffic_light_controller #(.FINAL_VALUE(33'd500)) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .Sa(Sa),
        .Sb(Sb),
        .R_a(R_a),
        .Y_a(Y_a),
        .G_a(G_a),
        .R_b(R_b),
        .Y_b(Y_b),
        .G_b(G_b)
    );
wire [1:0] light_A, light_B;
localparam R = 0;
localparam Y = 1;
localparam G = 2;

assign light_A = R_a ? R : (Y_a ? Y : (G_a ? G : 2'bxx));
assign light_B = R_b ? R : (Y_b ? Y : (G_b ? G : 2'bxx)); 

    // Clock generation: 100 MHz → 10 ns period
    always #5 clk = ~clk;

    initial begin
        $display("=== Starting 200 µs Traffic Light Simulation ===");
        
        clk = 0;
        reset = 0;
        enable = 1;
        Sa = 0;
        Sb = 0;

        // Apply reset
        #15 reset = 1;

        // --- Case 1: Sa = 1, Sb = 0 (0-50 µs) ---
        #5 Sa = 1; Sb = 0;
        #50_000;  // wait 50 µs

        // --- Case 2: Sa = 0, Sb = 1 (50-100 µs) ---
        Sa = 0; Sb = 1;
        #50_000;

        // --- Case 3: Sa = 1, Sb = 1 (100-160 µs) ---
        Sa = 1; Sb = 1;
        #60_000;

        // --- Case 4: Sa = 0, Sb = 1 (160-180 µs) ---
        Sa = 0; Sb = 1;
        #20_000;

        // --- Case 5: Sa = 1, Sb = 1 (180-200 µs) ---
        Sa = 1; Sb = 1;
        #20_000;

        $display("=== Simulation Complete at 200 µs ===");
        $finish;
    end

endmodule
