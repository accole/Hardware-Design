`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:57:33 05/03/2020
// Design Name:   TwosComp_to_SM
// Module Name:   /home/ise/Xilinx_VM/Project2/TwosComp_to_SM_tb.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TwosComp_to_SM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TwosComp_to_SM_tb;

	// Inputs
	reg [12:0] D;

	// Outputs
	wire S;
	wire [12:0] Mag;

	// Instantiate the Unit Under Test (UUT)
	TwosComp_to_SM uut (
		.D(D), 
		.S(S), 
		.Mag(Mag)
	);		

	initial begin
		// Initialize Inputs
		//D = 13'b0000000000000;
		//D = 13'b1111111111111;
		//D = 13'b1000000000001;
		D = 13'b1000000000000;

		// Wait 100 ns for global reset to finish
		#1000;
        
		// Add stimulus here
		$display("D: %b\nS: %b\nMag: %b", D, S, Mag);
		$finish;
	end
      
endmodule

