`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:16:14 05/09/2020
// Design Name:   clock_div_two
// Module Name:   /home/ise/Xilinx_VM/Project3/div_two_tb.v
// Project Name:  Project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_div_two
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module div_two_tb;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire clk_div_2;
	wire clk_div_4;
	wire clk_div_8;
	wire clk_div_16;

	// Instantiate the Unit Under Test (UUT)
	clock_div_two uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_2(clk_div_2), 
		.clk_div_4(clk_div_4), 
		.clk_div_8(clk_div_8), 
		.clk_div_16(clk_div_16)
	);


	//create input clock cycle
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
		rst = 1;   //reset clocks
		#100;
		rst = 0;
		#500;
		
		$finish;

	end
      
endmodule

