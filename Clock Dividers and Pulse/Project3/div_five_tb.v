`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:30:37 05/10/2020
// Design Name:   clock_div_five
// Module Name:   /home/ise/Xilinx_VM/Project3/div_five_tb.v
// Project Name:  Project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_div_five
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module div_five_tb;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire clock_div_5;

	// Instantiate the Unit Under Test (UUT)
	clock_div_five uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clock_div_5(clock_div_5)
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

