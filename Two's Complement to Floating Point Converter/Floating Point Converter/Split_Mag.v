`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:41:27 05/03/2020 
// Design Name: 
// Module Name:    Split_Mag 
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
module Split_Mag(
    input [12:0] Magnitude,
    output [2:0] E,
    output [4:0] F,
    output SixthBit
    );

reg temp_sixth;
reg [4:0] temp_f;
integer leadingZeros;

always @ (Magnitude)
	begin
		//determine # of leading zeros
		if (Magnitude[12])
			leadingZeros = 0;
		else if (Magnitude[11])
			begin
				leadingZeros = 1;
				temp_f = Magnitude[11:7];  //next 5 bits
				temp_sixth = Magnitude[6];  //6th bit
			end
		else if (Magnitude[10])
			begin
				leadingZeros = 2;
				temp_f = Magnitude[10:6];//next 5 bits
				temp_sixth = Magnitude[5];//6th bit
			end
		else if (Magnitude[9])
			begin
				leadingZeros = 3;
				temp_f = Magnitude[9:5];//next 5 bits
				temp_sixth = Magnitude[4];//6th bit
			end
		else if (Magnitude[8])
			begin
				leadingZeros = 4;
				temp_f = Magnitude[8:4];//next 5 bits
				temp_sixth = Magnitude[3];//6th bit
			end
		else if (Magnitude[7])
			begin
				leadingZeros = 5;
				temp_f = Magnitude[7:3];//next 5 bits
				temp_sixth = Magnitude[2];//6th bit
			end
		else if (Magnitude[6])
			begin
				leadingZeros = 6;
				temp_f = Magnitude[6:2];//next 5 bits
				temp_sixth = Magnitude[1];//6th bit
			end
		else if (Magnitude[5])
			begin
				leadingZeros = 7;
				temp_f = Magnitude[5:1];//next 5 bits
				temp_sixth = Magnitude[0];//6th bit
			end
		else if (Magnitude[4])
			begin
				leadingZeros = 8;
				temp_f = Magnitude[4:0];//next 5 bits
				temp_sixth = 0;
			end
		else
			begin
				leadingZeros = 8;
				temp_f = Magnitude[4:0];//next 5 bits
				temp_sixth = 0;
			end
		
			
		//if no leading zeros - handle negatives
		if (leadingZeros == 0)
			begin
				leadingZeros = 1;
				temp_sixth = 0;
				temp_f = 5'b11111;
			end

	end
	
assign SixthBit = temp_sixth;
assign E = ((8 - leadingZeros) == 0) ? 0 : (8 - leadingZeros);
assign F = temp_f;

endmodule
