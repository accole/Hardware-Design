`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:52:07 05/10/2020
// Design Name:   clock_strobe
// Module Name:   /home/ise/Xilinx_VM/Project3/strobe_tb.v
// Project Name:  Project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_strobe
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module strobe_tb;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire [7:0] glitchy_counter;

	// Instantiate the Unit Under Test (UUT)
	clock_strobe uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.glitchy_counter(glitchy_counter)
	);

	always
		begin
			#5;
			clk_in = ~clk_in;
		end

	initial begin
		// Initialize Inputs
		clk_in = 1;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 1;
		#100;
		rst = 0;
		#500;

		$finish;
		
	end
      
endmodule

