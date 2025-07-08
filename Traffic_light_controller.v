`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 19:23:27
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


module Traffic_light_controller #(
    parameter [32:0] FINAL_VALUE = 33'd500_000_000  // Default 5s @ 100 MHz
)(
    input clk,
    input reset,
    input enable,
    input Sa, Sb,
    output reg R_a, Y_a, G_a,
    output reg R_b, Y_b, G_b
);

    // Tick Generator
    wire done_tick;

    counter_tick_5_sec #(
        .BITS(33),
        .FINAL_VALUE(FINAL_VALUE)  // Can be overridden for testbench
    ) tick_gen (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .done(done_tick)
    );

    // FSM States
    localparam S0  = 0,  S1  = 1,  S2  = 2,  S3  = 3,  S4  = 4,
               S5  = 5,  S6  = 6,  S7  = 7,  S8  = 8,  S9  = 9,
               S10 = 10, S11 = 11, S12 = 12, S13 = 13, S14 = 14,
               S15 = 15, S16 = 16, S17 = 17, S18 = 18, S19 = 19,
               S20 = 20, S21 = 21, S22 = 22, S23 = 23, S24 = 24,
               S25 = 25, S26 = 26, S27 = 27;

    reg [4:0] q_present, q_next;

    // Present State Logic
    always @(posedge clk or negedge reset) begin
        if (~reset)
            q_present <= S0;
        else if (done_tick)
            q_present <= q_next;
        else
            q_present <= q_present;
    end

    // Next State Logic
    always @(*) begin
        if (enable) begin
            case (q_present)
                S0: q_next = S1;  S1: q_next = S2;  S2: q_next = S3;
                S3: q_next = S4;  S4: q_next = S5;  S5: q_next = S6;
                S6: q_next = S7;  S7: q_next = S8;  S8: q_next = S9;
                S9: q_next = S10; S10: q_next = S11; S11: q_next = S12;
                S12: q_next = S13; S13: q_next = S14;
                S14: q_next = S15; S15: q_next = S16;
                S16: q_next = S17; S17: q_next = S18; S18: q_next = S19;
                S19: q_next = S20; S20: q_next = S21; S21: q_next = S22;
                S22: q_next = S23; S23: q_next = S24; S24: q_next = S25;
                S25: begin
                    if (~Sa && Sb) q_next = S25;
                    else if (Sa || ~Sb) q_next = S26;
                    else q_next = S25;
                end
                S26: q_next = S27;
                S27: q_next = S0;
                default: q_next = S0;
            endcase
        end else begin
            q_next = q_present;
        end
    end

    // Output Logic
    always @(*) begin
        R_a = 0; Y_a = 0; G_a = 0;
        R_b = 0; Y_b = 0; G_b = 0;

        case (q_present)
            S0, S1, S2, S3, S4, S5, S6, S7,
            S8, S9, S10, S11, S12, S13: begin
                G_a = 1;
                R_b = 1;
            end
            S14, S15: begin
                Y_a = 1;
                R_b = 1;
            end
            S16, S17, S18, S19, S20,
            S21, S22, S23, S24, S25: begin
                R_a = 1;
                G_b = 1;
            end
            S26, S27: begin
                R_a = 1;
                Y_b = 1;
            end
            default: begin
                R_a = 1;
                R_b = 1;
            end
        endcase
    end

endmodule