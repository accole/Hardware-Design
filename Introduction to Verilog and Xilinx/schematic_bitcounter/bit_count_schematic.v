`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:00:41 04/20/2020 
// Design Name: 
// Module Name:    bit_count_schematic 
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
module bit_count_schematic(
    input clk,
    input rst,
    output reg r1,
    output reg r2,
    output reg r3,
    output reg r4
    );

always @ (posedge clk or posedge rst)
	begin
		if (rst)  //reset
		begin
				r1 <= 0;
				r2 <= 0;
				r3 <= 0;
				r4 <= 0;
		end
		else
		begin
				r1 <= ~r1;  //flip last state
				r2 <= r1^r2;  //follow the logic in diagram
				r3 <= (r1 & r2)^r3;
				r4 <= ((r1 & r2) & r3)^r4;
		end
	end

endmodule
