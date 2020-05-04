`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:49:56 05/04/2020 
// Design Name: 
// Module Name:    rounder 
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
module rounder(
    input [2:0] E_in,
    input [4:0] F_in,
    input Sixth,
    output [2:0] E_out,
    output [4:0] F_out
    );


reg [5:0] store;  //need 1 extra bit
reg [2:0] temp_E;


always @*
	begin
	
		//hard code special case
		if (F_in == 5'b11111 && E_in == 3'b111 && Sixth == 1)
			begin
				store = 6'b011111;
				temp_E = 3'b111;
			end
		//else general case
		else
			begin
				//add sixth bit
				if (Sixth)
					store = F_in + 1;
				else
					store = F_in;
					
				//test and shift
				if (store[5])
					begin
						store = store >> 1;
						temp_E = E_in + 1;
					end
				else
					temp_E = E_in;
			end
	end


assign F_out = store[4:0];
assign E_out = temp_E;

endmodule
