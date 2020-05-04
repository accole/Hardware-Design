//`timescale 1ns / 1ps
`timescale 1us / 1ns
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:33:51 04/20/2020
// Design Name:   clock_div
// Module Name:   /home/ise/Xilinx_VM/clock_div_10khz/clock_div_tb.v
// Project Name:  clock_div_10khz
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clock_div_tb;

	// Inputs
	reg rst;
	reg clk_in;

	// Outputs
	wire clk_out;

	// Instantiate the Unit Under Test (UUT)
	clock_div uut (
		.rst(rst), 
		.clk_in(clk_in), 
		.clk_out(clk_out)
	);


	//10 kHz
	always
		begin
			#50;
			clk_in = ~clk_in;
		end

	initial begin
		// Initialize Inputs
		rst = 0;
		clk_in = 1;

		// Wait 100 ns for global reset to finish
		//#1;
        
		// Add stimulus here
		rst = 1;
		#50;
		//start
		rst = 0;
		#1000;
		$finish;

	end
      
endmodule

