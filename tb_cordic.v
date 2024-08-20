// Code your testbench here
// or browse Examples
module tb_cordic;

    // Testbench signals
    reg clk;
    reg reset;
    reg [31:0] angle_in;
    wire [31:0] cos_out;
    wire [31:0] sin_out;

    // Instantiate the CORDIC module
    cordic uut (
        .clk(clk),
        .reset(reset),
        .angle_in(angle_in),
        .cos_out(cos_out),
        .sin_out(sin_out)
    );

    // Clock generation
    initial begin
      $dumpfile("dump.vcd");
    $dumpvars(1);
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10 time units
    end

    // Test sequence
    initial begin
        // Initialize signals


        // Apply test angles with reset handling
        apply_angle(32'h00000000); // 0 degrees
        #20; // Wait for 16 iterations + extra time

        apply_angle(32'h41F00000); // 30 degrees
        #20;

        apply_angle(32'h42340000); // 45 degrees
        #20;

        apply_angle(32'h42700000); // 60 degrees
        #20;

        apply_angle(32'h42B40000); // 90 degrees
        #20;

        apply_angle(32'h42F00000); // 120 degrees
        #20;

        apply_angle(32'h43180000); // 135 degrees
        #20;

        apply_angle(32'h43340000); // 150 degrees
        #20;

        apply_angle(32'h43480000); // 180 degrees
        #20;

        apply_angle(32'h43680000); // 210 degrees
        #20;

        apply_angle(32'h43700000); // 225 degrees
        #20;

        apply_angle(32'h43800000); // 240 degrees
        #20;

        apply_angle(32'h43900000); // 270 degrees
        #20;

        apply_angle(32'h43A00000); // 300 degrees
        #20;

        apply_angle(32'h43A80000); // 315 degrees
        #20;

        apply_angle(32'h43B80000); // 330 degrees
        #20;

        apply_angle(32'h43C80000); // 360 degrees
        #20;

        // End the simulation
        $stop;
    end

    // Task to apply angle and wait for reset and computation
    task apply_angle(input [31:0] angle);
        begin
            // Apply reset
            reset = 1;
            #20; // Wait for 2 clock cycles
            
            // Release reset
            angle_in = angle;
            reset = 0;
            //#10; // Wait for 1 clock cycle before applying the angle
            
            // Apply the angle
    
            
            // Wait for min 16 clock cycles to ensure the computation is complete
            #230;
          // Display the results
            $display("Input Angle (hex): %h", angle);
            $display("Cosine Output (hex): %h", cos_out);
            $display("Sine Output (hex): %h", sin_out);
          $display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
        end
    endtask
  

endmodule
