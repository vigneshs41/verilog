// Code your design here
module cordic(
    input wire clk,                  // Clock signal
    input wire reset,                // Reset signal
    input wire [31:0] angle_in,      // 32-bit floating-point input angle (0 to 360 degrees)
    output reg [31:0] cos_out,       // 32-bit floating-point output cosine
    output reg [31:0] sin_out        // 32-bit floating-point output sine
);
    // Parameters for iteration (precomputed angles in fixed-point format)
    reg [31:0] atan_table [0:15];

    // Internal registers for the CORDIC computation
    reg [31:0] x, y, z;              // x, y coordinates and z (angle)
    reg [4:0] i;                     // Iteration index
    reg [31:0] k_factor;             // Scaling factor

    // Constants
    parameter K = 32'h3F76C16C;      // CORDIC gain correction factor in floating-point

    // Initial block to set the scaling factor
 // CORDIC rotation iterations
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            k_factor = K;
          
            atan_table[0] = 32'h3F490FDB; // arctan(2^0) = 45 degrees
            atan_table[1] = 32'h3F15C28F; // arctan(2^-1) = 26.565 degrees
            atan_table[2] = 32'h3EFB15B3; // arctan(2^-2) = 14.036 degrees
            atan_table[3] = 32'h3EAB8D2B; // arctan(2^-3) = 7.125 degrees
            atan_table[4] = 32'h3E6D47CC; // arctan(2^-4) = 3.576 degrees
            atan_table[5] = 32'h3E3A1A64; // arctan(2^-5) = 1.790 degrees
            atan_table[6] = 32'h3E1A13CD; // arctan(2^-6) = 0.895 degrees
            atan_table[7] = 32'h3E046C7E; // arctan(2^-7) = 0.448 degrees
            atan_table[8] = 32'h3DEBD3F1; // arctan(2^-8) = 0.224 degrees
            atan_table[9] = 32'h3DDCD044; // arctan(2^-9) = 0.112 degrees
            atan_table[10] = 32'h3DCD99FB;// arctan(2^-10) = 0.056 degrees
            atan_table[11] = 32'h3DBFDCBF;// arctan(2^-11) = 0.028 degrees
            atan_table[12] = 32'h3DB2B2D0;// arctan(2^-12) = 0.014 degrees
            atan_table[13] = 32'h3DA6A1A5;// arctan(2^-13) = 0.007 degrees
            atan_table[14] = 32'h3D9B8A23;// arctan(2^-14) = 0.0035 degrees
            atan_table[15] = 32'h3D916E53;// arctan(2^-15) = 0.00175 degrees
          
            // Initialize registers
            x <= 32'h3F800000; // 1.0 in floating point
            y <= 32'h00000000; // 0.0 in floating point
            z <= angle_in;     // Input angle
            i <= 0;
        end else if (i < 16) begin
            if (z[31] == 1) begin
                // Rotate clockwise
                x <= x + (y >>> i);
                y <= y - (x >>> i);
                z <= z + atan_table[i];
            end else begin
                // Rotate counter-clockwise
                x <= x - (y >>> i);
                y <= y + (x >>> i);
                z <= z - atan_table[i];
            end
            i <= i + 1;
        end else begin
            // Apply scaling factor to correct the magnitude
            cos_out <= x * k_factor;
            sin_out <= y * k_factor;
        end
    end
endmodule
