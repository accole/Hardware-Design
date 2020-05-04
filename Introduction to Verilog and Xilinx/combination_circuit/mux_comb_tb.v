`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:47:35 04/19/2020
// Design Name:   mux_comb
// Module Name:   /home/ise/Xilinx_VM/combination_circuit/mux_comb_tb.v
// Project Name:  combination_circuit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mux_comb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mux_comb_tb;

	// Inputs
	reg SW0;
	reg SW1;
	reg [2:0] SW2;

	// Outputs
	wire LED;

	// Instantiate the Unit Under Test (UUT)
	mux_comb uut (
		.SW0(SW0), 
		.SW1(SW1), 
		.SW2(SW2), 
		.LED(LED)
	);
	
	//variables
	reg [3:0] count;

	initial begin
		// Initialize Inputs
		SW0 = 1;
		SW1 = 0;
		SW2 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		SW1 = 1;
		SW2 = 0;
		#50;
		
		//change mux values after certain period of time
		count = 0;
		while (count < 9)
			begin
				count = count + 1;
				SW2 = SW2 + 1;
				#50;
			end
		$finish;
	end
      
endmodule

