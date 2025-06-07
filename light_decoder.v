`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 13:22:52
// Design Name: 
// Module Name: light_decoder
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
module light_decoder (
    input [1:0] light_cmd,    // Control input
    output reg red,
    output reg yellow,
    output reg green
);

    always @(*) begin
        // Default outputs (safe state)
        red = 1'b0;
        yellow = 1'b0;
        green = 1'b0;

        case(light_cmd)
            2'b00: red = 1'b1;     // Red
            2'b01: yellow = 1'b1;  // Yellow
            2'b10: green = 1'b1;   // Green
            default: red = 1'b1;   // Error state (red)
        endcase
    end
endmodule
