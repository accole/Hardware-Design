`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:05:22 04/20/2020
// Design Name:   bit_count_schematic
// Module Name:   /home/ise/Xilinx_VM/schematic_bitcount/bitcount_schematic_tb.v
// Project Name:  schematic_bitcount
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bit_count_schematic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bitcount_schematic_tb;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire r1;
	wire r2;
	wire r3;
	wire r4;

	// Instantiate the Unit Under Test (UUT)
	bit_count_schematic uut (
		.clk(clk), 
		.rst(rst), 
		.r1(r1), 
		.r2(r2), 
		.r3(r3), 
		.r4(r4)
	);

	always
		begin
			#5;
			clk = ~clk;
		end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
		#200;
		$finish;

	end
      
endmodule

