module clock_prescaler #(
    parameter CLK_FREQ = 50_000_000,
    parameter OUT_FREQ = 1
)(
    input wire clk,
    input wire reset,
    input wire enable,     // Add enable port
    output reg out_clk
);

    localparam integer MAX_COUNT = CLK_FREQ / (2 * OUT_FREQ);
    integer count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            out_clk <= 0;
        end else if (enable) begin
            if (count == MAX_COUNT - 1) begin
                count <= 0;
                out_clk <= ~out_clk;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule

