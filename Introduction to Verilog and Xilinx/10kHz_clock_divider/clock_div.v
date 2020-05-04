`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:33:06 04/20/2020 
// Design Name: 
// Module Name:    clock_div 
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
module clock_div(
    input rst,
    input clk_in,
    output clk_out
    );

//create 4 bit counter
reg [3:0] counter;


always @ (posedge clk_in)  //at posedge of 10-kHz
	begin
		if (rst)
			counter <= 4'b0000;
		else if (counter == 4'b1001)  //reset counter at start of 11th cycle
			counter <= 4'b0000;
		else
			counter <= counter + 1'b1;  //increment counter
	end

//1-kHz clock - toggle counter every 5th cycle
assign clk_out = ((counter > 4'b0100) ? 1'b0 : 1'b1);

endmodule
