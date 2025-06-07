`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 13:30:43
// Design Name: 
// Module Name: traffic_controller
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

module traffic_controller #(
    parameter CLK_FREQ = 50_000_000  // 50 MHz system clock
) (
    input clk,
    input reset,
    // Light outputs
    output ns_red, ns_yellow, ns_green,
    output ew_red, ew_yellow, ew_green
);

    // Control signals
    wire load_enable;
    wire time_sel;
    wire [1:0] ns_light_cmd;
    wire [1:0] ew_light_cmd;
    
    // Status signal
    wire timer_zero;
    
    // Control path
    control_path ctrl (
        .clk(clk),
        .reset(reset),
        .timer_zero(timer_zero),
        .load_enable(load_enable),
        .time_sel(time_sel),
        .ns_light_cmd(ns_light_cmd),
        .ew_light_cmd(ew_light_cmd)
    );
    
    // Data path
    data_path #(
        .CLK_FREQ(CLK_FREQ)
    ) datapath (
        .clk(clk),
        .reset(reset),
        .load_enable(load_enable),
        .time_sel(time_sel),
        .ns_light_cmd(ns_light_cmd),
        .ew_light_cmd(ew_light_cmd),
        .timer_zero(timer_zero),
        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),
        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green)
    );

endmodule
