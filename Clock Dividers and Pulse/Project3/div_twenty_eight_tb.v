`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:48:31 05/09/2020
// Design Name:   clock_div_twenty_eight
// Module Name:   /home/ise/Xilinx_VM/Project3/div_twenty_eight_tb.v
// Project Name:  Project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_div_twenty_eight
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module div_twenty_eight_tb;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire clk_div_28;

	// Instantiate the Unit Under Test (UUT)
	clock_div_twenty_eight uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_28(clk_div_28)
	);

	//create clock
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

