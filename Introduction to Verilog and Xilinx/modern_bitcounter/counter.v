`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:05:21 04/19/2020 
// Design Name: 
// Module Name:    counter 
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
module counter(
    input clk,   //clock input
    input rst,   //reset
    output reg [3:0] out  //current count
    );

always @ (posedge clk or posedge rst)  //run on clock posedge or clock reset
begin
	if (rst)   //if reset
		out <= 4'b0000;  //set counter to 0
	else    //else
		out <= out + 1'b1;   //increment counter by 1 bit
end

endmodule
