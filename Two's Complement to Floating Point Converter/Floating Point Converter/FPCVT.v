`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:16:24 05/03/2020 
// Design Name: 
// Module Name:    FPCVT 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FPCVT(
    input [12:0] D,
    output S,
    output [2:0] E,
    output [4:0] F
    );
	 
	//define our interdependencies between modules
	wire [12:0] Mag;
	wire SixthBit;
	wire [2:0] E_mid;
	wire [4:0] F_mid;

	// Extract sign bit and magnitude
	TwosComp_to_SM mod1 (
		.D(D), 
		.S(S), 
		.Mag(Mag)
	);			 


	//split magnitude into E, F, and SixthBit
	Split_Mag mod2 (
		.Magnitude(Mag), 
		.E(E_mid), 
		.F(F_mid), 
		.SixthBit(SixthBit)
	);
	
	
	//round floating point value
	rounder mod3 (
		.E_in(E_mid), 
		.F_in(F_mid), 
		.Sixth(SixthBit), 
		.E_out(E), 
		.F_out(F)
	);


endmodule
