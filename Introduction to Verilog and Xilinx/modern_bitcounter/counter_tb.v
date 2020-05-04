`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:13:50 04/19/2020
// Design Name:   counter
// Module Name:   /home/ise/Xilinx_VM/bitcounter_4/counter_tb.v
// Project Name:  bitcounter_4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module counter_tb;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [3:0] out;

	// Instantiate the Unit Under Test (UUT)
	counter uut (
		.clk(clk), 
		.rst(rst), 
		.out(out)
	);
	
	always
	begin
		#5;
		clk = ~clk;  //every 5ns flip clock
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
       
		// Add stimulus here
		rst <= 1;    //reset counter
		#20
		rst <= 0;     //start counting
		#250;         //let it run for 250ns
		rst <= 1;    //reset again
		#20;
		
		$finish;
	end
      
endmodule

