`timescale 1ns / 1ps

module tb_traffic_controller();

    // Simulation parameters
    parameter CLK_PERIOD = 10;  // 10ns period (arbitrary for simulation)
    parameter CLK_FREQ_SIM = 1;  // 1Hz enable signal = 1 second per clock cycle
    
    // Signals
    reg clk;
    reg reset;
    wire ns_red, ns_yellow, ns_green;
    wire ew_red, ew_yellow, ew_green;
    
    // Instantiate DUT with simulation parameters
    traffic_controller #(
        .CLK_FREQ(CLK_FREQ_SIM)
    ) dut (
        .clk(clk),
        .reset(reset),
        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),
        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Reset and stimulus
    initial begin
        // Initialize and apply reset
        reset = 1;
        #(CLK_PERIOD * 2);
        reset = 0;
        $display("[%0t] Reset released", $time);
        
        // Run simulation for 70 seconds (70 clock cycles)
        #(CLK_PERIOD * 70);
        
        $display("[%0t] Simulation complete (70 seconds)", $time);
        $finish;
    end
    
    // State monitoring
    reg [7:0] seconds = 0;
    
    always @(posedge clk) begin
        if (!reset) seconds <= seconds + 1;
    end
    
    // Display state changes
    always @(posedge clk) begin
        if (reset) begin
            $display("Time\tNS Light\tEW Light");
            $display("----------------------------------");
        end
        else begin
            $write("%0ds:\t", seconds);
            
            // Display NS light
            if (ns_green)       $write("GREEN");
            else if (ns_yellow) $write("YELLOW");
            else if (ns_red)    $write("RED");
            else                $write("ERROR");
            
            $write("\t\t");
            
            // Display EW light
            if (ew_green)       $write("GREEN");
            else if (ew_yellow) $write("YELLOW");
            else if (ew_red)    $write("RED");
            else                $write("ERROR");
            
            $display();
        end
    end
    
    // Safety checks
    always @(posedge clk) begin
        if (!reset) begin
            // Check only one light active per road
            if ((ns_red + ns_yellow + ns_green) !== 1) begin
                $display("ERROR: %0ds - NS conflict: R:%b Y:%b G:%b", 
                        seconds, ns_red, ns_yellow, ns_green);
            end
            
            if ((ew_red + ew_yellow + ew_green) !== 1) begin
                $display("ERROR: %0ds - EW conflict: R:%b Y:%b G:%b", 
                        seconds, ew_red, ew_yellow, ew_green);
            end
            
            // Check no green conflict
            if (ns_green && ew_green) begin
                $display("ERROR: %0ds - Both roads green!", seconds);
            end
        end
    end
    
    // VCD dump for waveform viewing
    initial begin
        $dumpfile("traffic_controller.vcd");
        $dumpvars(0, tb_traffic_controller);
    end
endmodule


