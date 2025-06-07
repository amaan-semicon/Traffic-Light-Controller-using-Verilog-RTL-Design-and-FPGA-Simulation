`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 13:29:30
// Design Name: 
// Module Name: control_path
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


module control_path (
    input clk,
    input reset,
    input timer_zero,          // Status from data path
    output reg load_enable,    // To data path
    output reg time_sel,       // To data path (0: green, 1: yellow)
    output reg [1:0] ns_light_cmd,  // NS light command
    output reg [1:0] ew_light_cmd   // EW light command
);

    // State definitions with gray encoding
    localparam [1:0] S0 = 2'b00,  // NS Green, EW Red
                     S1 = 2'b01,  // NS Yellow, EW Red
                     S2 = 2'b11,  // NS Red, EW Green
                     S3 = 2'b10;  // NS Red, EW Yellow

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            prev_state <= S0;
        end else begin
            current_state <= next_state;
            prev_state <= current_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = timer_zero ? S1 : S0;
            S1: next_state = timer_zero ? S2 : S1;
            S2: next_state = timer_zero ? S3 : S2;
            S3: next_state = timer_zero ? S0 : S3;
            default: next_state = S0;
        endcase
    end

    // Output logic with single-cycle load_enable pulse on state change
    always @(*) begin
        // Default safe outputs
        load_enable = 1'b0;
        time_sel = 1'b0;
        ns_light_cmd = 2'b00;  // Red
        ew_light_cmd = 2'b00;  // Red

        case (current_state)
            S0: begin
                ns_light_cmd = 2'b10;  // Green
                ew_light_cmd = 2'b00;  // Red
                time_sel = 1'b0;       // green time
            end
            S1: begin
                ns_light_cmd = 2'b01;  // Yellow
                ew_light_cmd = 2'b00;  // Red
                time_sel = 1'b1;       // yellow time
            end
            S2: begin
                ns_light_cmd = 2'b00;  // Red
                ew_light_cmd = 2'b10;  // Green
                time_sel = 1'b0;       // green time
            end
            S3: begin
                ns_light_cmd = 2'b00;  // Red
                ew_light_cmd = 2'b01;  // Yellow
                time_sel = 1'b1;       // yellow time
            end
            default: begin
                ns_light_cmd = 2'b00;
                ew_light_cmd = 2'b00;
                time_sel = 1'b0;
            end
        endcase

        // Pulse load_enable when state changes (current != prev)
        load_enable = (current_state != prev_state);
    end

endmodule

