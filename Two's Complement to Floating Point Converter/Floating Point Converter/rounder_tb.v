`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:20:04 05/04/2020
// Design Name:   rounder
// Module Name:   /home/ise/Xilinx_VM/Project2/rounder_tb.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rounder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rounder_tb;

	// Inputs
	reg [2:0] E_in;
	reg [4:0] F_in;
	reg Sixth;

	// Outputs
	wire [2:0] E_out;
	wire [4:0] F_out;

	// Instantiate the Unit Under Test (UUT)
	rounder uut (
		.E_in(E_in), 
		.F_in(F_in), 
		.Sixth(Sixth), 
		.E_out(E_out), 
		.F_out(F_out)
	);

	initial begin
		// Initialize Inputs
		E_in = 3'b000;
		F_in = 5'b00000;
		Sixth = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		E_in = 3'b001;
		F_in = 5'b11111;
		Sixth = 1;
		#1000;

		$finish;

	end
      
endmodule

