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

Traffic_light_controller tfc(
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

always #5 clk = ~clk;

initial begin
    // Initialize inputs
    clk = 1'b0;
    reset = 1'b0;
    enable = 1'b1;  // Enable controller operation
    Sa = 1'b0;
    Sb = 1'b0;
    
    // Apply reset
    #2 reset = 1'b1;
    
    // Test sequence
    repeat(7) @(negedge clk);
    Sb = 1'b1;
    repeat(7) @(negedge clk);
    Sa = 1'b1;
    repeat(7) @(negedge clk);
    Sb = 1'b1;
    repeat(5) @(negedge clk);
    Sa = 1'b0;
    repeat(2) @(negedge clk);
    Sa = 1'b1;
    
    #100 $finish;
end

endmodule

