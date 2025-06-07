`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 13:23:39
// Design Name: 
// Module Name: data_path
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


module data_path #(
    parameter CLK_FREQ = 50_000_000
) (
    input clk,
    input reset,
    // Control signals
    input load_enable,
    input time_sel,
    input [1:0] ns_light_cmd,
    input [1:0] ew_light_cmd,
    // Status signals
    output timer_zero,
    // Light outputs
    output ns_red, ns_yellow, ns_green,
    output ew_red, ew_yellow, ew_green
);

    // Internal signals
    wire enable_1Hz;
    wire [5:0] load_value;
    wire [5:0] counter_value;
    
    // Timing constants
    wire [5:0] green_time = 6'd30;  // 30 seconds
    wire [5:0] yellow_time = 6'd5;  // 5 seconds

    // Module instantiations
    clock_prescaler #(
        .CLK_FREQ(CLK_FREQ)
    ) prescaler (
        .clk(clk),
        .reset(reset),
        .enable(enable_1Hz)
    );
    
    time_mux mux (
        .time_sel(time_sel),
        .green_time(green_time),
        .yellow_time(yellow_time),
        .load_value(load_value)
    );
    
    down_counter #(
        .WIDTH(6)
    ) counter (
        .clk(clk),
        .reset(reset),
        .enable(enable_1Hz),
        .load_enable(load_enable),
        .load_value(load_value),
        .timer_zero(timer_zero),
        .count(counter_value)
    );
    
    light_decoder ns_decoder (
        .light_cmd(ns_light_cmd),
        .red(ns_red),
        .yellow(ns_yellow),
        .green(ns_green)
    );
    
    light_decoder ew_decoder (
        .light_cmd(ew_light_cmd),
        .red(ew_red),
        .yellow(ew_yellow),
        .green(ew_green)
    );

endmodule
