`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 18:56:51
// Design Name: 
// Module Name: counter_tick_5_sec
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


module counter_tick_5_sec #(
    parameter BITS = 33,
    parameter [BITS-1:0] FINAL_VALUE = 33'd500_000_000  // Default: 5s @ 100 MHz
)(
    input clk,
    input reset,
    input enable,
    output done
);

    reg [BITS-1:0] q_present, q_next;

    // Present-state logic
    always @(posedge clk or negedge reset) begin
        if (~reset)
            q_present <= 'b0;
        else if (enable)
            q_present <= q_next;
        else
            q_present <= q_present;
    end

    // Next-state logic
    always @(*) begin
        if (done)
            q_next = 'b0;
        else
            q_next = q_present + 1;
    end

    // Done when count reaches FINAL_VALUE
    assign done = (q_present == FINAL_VALUE);

endmodule
