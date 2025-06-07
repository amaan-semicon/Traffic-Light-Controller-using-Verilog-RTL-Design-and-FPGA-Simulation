`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 13:22:03
// Design Name: 
// Module Name: time_mux
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


module time_mux (
    input time_sel,           // Control signal
    input [5:0] green_time,   // 30 seconds
    input [5:0] yellow_time,  // 5 seconds
    output reg [5:0] load_value
);

    always @(*) begin
        case(time_sel)
            1'b0: load_value = green_time;   // Select green time
            1'b1: load_value = yellow_time;  // Select yellow time
            default: load_value = green_time;
        endcase
    end
endmodule
