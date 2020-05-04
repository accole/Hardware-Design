`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:21:31 05/04/2020
// Design Name:   Split_Mag
// Module Name:   /home/ise/Xilinx_VM/Project2/Mag_Split_tb.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Split_Mag
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Mag_Split_tb;

	// Inputs
	reg [12:0] Magnitude;

	// Outputs
	wire [2:0] E;
	wire [4:0] F;
	wire SixthBit;

	// Instantiate the Unit Under Test (UUT)
	Split_Mag uut (
		.Magnitude(Magnitude), 
		.E(E), 
		.F(F), 
		.SixthBit(SixthBit)
	);

	initial begin
		// Initialize Inputs
		Magnitude = 13'b1000000000000;
		//Magnitude = 13'b1111111111111;
		//Magnitude = 13'b1000000000001;
		//Magnitude = 13'b1000000000000;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Magnitude = 13'b1111111111111;
		#1000;
		$display("E: %b\nF: %b\n6th: %b", E, F, SixthBit);
		$finish;

	end
      
endmodule

