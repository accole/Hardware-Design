`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:06 05/03/2020 
// Design Name: 
// Module Name:    TwosComp_to_SM 
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
module TwosComp_to_SM(
    input [12:0] D,
    output S,
    output [12:0] Mag
    );


	//create var to store magnitude
	reg [12:0] store;
	reg sign;
	
	//at any variable change
	always @*
		begin
			sign = D[12];
			if (sign == 1)
				store = ~D + 12'b1; 	//if negative, complement and add 1
			else
				store = D;
		end
	
	assign S = D[12];   //sign bit is always msb of D
	assign Mag = store; //update magnitude as a wire

endmodule
