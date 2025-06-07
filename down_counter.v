`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 13:21:12
// Design Name: 
// Module Name: down_counter
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


module down_counter #(
    parameter WIDTH = 6
) (
    input clk,
    input reset,
    input enable,
    input load_enable,
    input [WIDTH-1:0] load_value,
    output reg timer_zero,
    output reg [WIDTH-1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            timer_zero <= 0;
        end
        else if (load_enable) begin
            count <= load_value;
            timer_zero <= 0;
        end
        else if (enable) begin
            if (count == 0) begin
                timer_zero <= 1;
            end
            else begin
                count <= count - 1;
                timer_zero <= 0;
            end
        end
        else begin
            timer_zero <= 0;
        end
    end
endmodule
