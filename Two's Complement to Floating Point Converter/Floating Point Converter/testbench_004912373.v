`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:45:39 05/04/2020
// Design Name:   FPCVT
// Module Name:   /home/ise/Xilinx_VM/Project2/testbench_004912373.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_004912373;

	// Inputs
	reg [12:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);

	initial begin
		// Initialize Inputs
		//D = 13'b0000000000000   //easy case all 0's
		//D = 13'b1000000000000	  //-4096 special case
		//D = 13'b0111111111111   //same output as above except sign bit
		D = 13'b1111110000001;   //bits have to flip, overflow, shift, etc.
		//D = 13'b0000000101101;

		// Wait 100 ns for global reset to finish
		#1000;
        
		// Add stimulus here
		$finish;

	end
      
endmodule

