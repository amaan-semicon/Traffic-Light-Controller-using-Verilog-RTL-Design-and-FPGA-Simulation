`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2025 01:00:28
// Design Name: 
// Module Name: Traffic_light_controller
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


module Traffic_light_controller(
    input clk,
    input reset,
    input enable,
    input Sa, Sb,
    output reg R_a, Y_a, G_a,
    output reg R_b, Y_b, G_b
);

localparam S0 = 0;
localparam S1 = 1;
localparam S2 = 2;
localparam S3 = 3;
localparam S4 = 4;
localparam S5 = 5;
localparam S6 = 6;
localparam S7 = 7;
localparam S8 = 8;
localparam S9 = 9;
localparam S10 = 10;
localparam S11 = 11;
localparam S12 = 12;

reg [3:0] state_present, state_next;

// Present state logic
always @(posedge clk or negedge reset) begin
    if (~reset)
        state_present <= S0;
    else
        state_present <= state_next;
end

// Next state logic with enable control
always @(*) begin
    if (enable) begin
        case (state_present)
            S0: state_next = S1;
            S1: state_next = S2;
            S2: state_next = S3;
            S3: state_next = S4;
            S4: state_next = S5;
            S5: if (~Sb) state_next = S5;
                 else if (Sb) state_next = S6;
            S6: state_next = S7;
            S7: state_next = S8;
            S8: state_next = S9;
            S9: state_next = S10;
            S10: state_next = S11;
            S11: if ((~Sa) & (Sb)) state_next = S11;
                 else if ((Sa) | (~Sb)) state_next = S12;
            S12: state_next = S0;
            default: state_next = S0;
        endcase
    end
    else begin
        state_next = state_present;  // Maintain current state when disabled
    end
end

// Output logic
always @(*) begin
    // Default assignments
    R_a = 1'b0;
    Y_a = 1'b0;
    G_a = 1'b0;
    R_b = 1'b0;
    Y_b = 1'b0;
    G_b = 1'b0;
    
    case (state_present)
        S0, S1, S2, S3, S4, S5: begin 
            G_a = 1'b1; 
            R_b = 1'b1; 
        end
        S6: begin 
            Y_a = 1'b1; 
            R_b = 1'b1; 
        end
        S7, S8, S9, S10, S11: begin 
            R_a = 1'b1; 
            G_b = 1'b1; 
        end
        S12: begin 
            R_a = 1'b1; 
            Y_b = 1'b1; 
        end
    endcase
end

endmodule