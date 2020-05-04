`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:21:23 04/19/2020 
// Design Name: 
// Module Name:    mux_comb 
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
module mux_comb(
    input SW0,
    input SW1,
    input [2:0] SW2,
    output reg LED
    );

	always @(SW0 or SW1 or SW2)  //run mux everytime inputs change
	begin
		case (SW2)   //MUX value
			0: LED = ~SW0;   //not gate
			1: LED = SW0;    //non inverting buffer
			2: LED = SW0 ~^ SW1;  //xnor
			3: LED = SW0 ^ SW1;   //xor
			4: LED = SW0 | SW1;  //or
			5: LED = ~(SW0 | SW1);  //nor
			6: LED = SW0 & SW1;  //and
			7: LED = ~(SW0 & SW1);  //nand
			default: LED = SW0;   //default LED to SW0
		endcase
	end
endmodule
