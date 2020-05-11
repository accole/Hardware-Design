`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:27 05/09/2020 
// Design Name: 
// Module Name:    clock_gen 
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
module clock_gen(
    input clk_in,
    input rst,
    output clk_div_2,
    output clk_div_4,
    output clk_div_8,
    output clk_div_16,
    output clk_div_28,
    output clk_div_5,
    output [7:0] glitchy_counter
    );

clock_div_two task_one(
	.clk_in (clk_in),
	.rst (rst),
	.clk_div_2(clk_div_2),
	.clk_div_4(clk_div_4),
	.clk_div_8(clk_div_8),
	.clk_div_16(clk_div_16)
);

clock_div_twenty_eight task_two(
	.clk_in (clk_in),
	.rst (rst),
	.clk_div_28(clk_div_28)
);

clock_div_five task_three(
	.clk_in (clk_in),
	.rst (rst),
	.clock_div_5(clk_div_5)
);

clock_strobe task_four(
	.clk_in (clk_in),
	.rst (rst),
	.glitchy_counter (glitchy_counter)
);


endmodule


module clock_div_two(
    input clk_in,
    input rst,
    output clk_div_2,
    output clk_div_4,
    output clk_div_8,
    output clk_div_16
    );


reg [3:0] count;

//run on clock posedge
always @ (posedge clk_in)
begin
	if (rst)   //if reset
		count <= 4'b0000;  //set counter to 0
	else    //else
		count <= count + 1'b1;   //increment counter by 1 bit
end

assign clk_div_2 = count[0];    //assign each clk_div one of the bits
assign clk_div_4 = count[1];
assign clk_div_8 = count[2];
assign clk_div_16 = count[3];

endmodule


module clock_div_twenty_eight(
    input clk_in,
    input rst,
    output clk_div_28
    );

//create 4 bit counter and a toggle
reg start;
reg toggle;
reg [3:0] count;

always @ (posedge clk_in)  //run on clock posedge
begin
	if (rst)   //if reset
		begin
			count <= 4'b0000;  //set counter to 0
			toggle <= 1'b0;
			start <= 1'b0;
		end
	else if ((start == 1) && (count == 14))   //at overflow
		begin
			count <= 4'b0001;
			toggle <= ~toggle;
		end
	else    //else
		begin
			count <= count + 1'b1;   //increment counter by 1 bit
			start <= 1'b1;
		end
end

assign clk_div_28 = toggle;

endmodule


module clock_div_five(
    input clk_in,
    input rst,
    output clock_div_5
    );


reg [2:0] count_pos;  //counter
reg [2:0] count_neg;  //counter
reg duty_pos;   //duty cycle for posedge
reg duty_neg;   //duty cycle for negedge
 
  
//toggle positive edge duty cycle
always @ (count_pos)
	begin
		if (rst)
			duty_pos <= 1'b0;
		else if (count_pos == 1)
			duty_pos <= ~duty_pos;
		else if (count_pos == 3)
			duty_pos <= ~duty_pos;
		else
			duty_pos <= duty_pos;
	end

//toggle negative edge duty cycle
always @ (count_neg)
	begin
		if (rst)
			duty_neg <= 1'b0;
		else if (count_neg == 1)
			duty_neg <= ~duty_neg;
		else if (count_neg == 3)
			duty_neg <= ~duty_neg;
		else
			duty_neg <= duty_neg;
	end

//counter for positive edge
always @ (posedge clk_in)
	begin
		if (rst)
			begin
				count_pos <= 1'b0;
				//duty_pos <= 1'b0;
			end
		else if (count_pos == 5)
			count_pos <= 1'b1;  //reset counter
		else
			count_pos <= count_pos + 1'b1;
	end

//counter for negative edge
always @ (negedge clk_in)
	begin
		if (rst)
			begin
				count_neg <= 1'b0;
				//duty_neg = 1'b0;
			end
		else if (count_neg == 5)
			count_neg <= 1'b1;  //reset counter
		else
			count_neg <= count_neg + 1'b1;
	end
	
//or duty cycles to divide clk_in
assign clock_div_5 = duty_pos | duty_neg;

endmodule


module clock_strobe(
    input clk_in,
    input rst,
    output reg [7:0] glitchy_counter
    );

reg [1:0] count;
reg duty_4;
reg start;


//create glitchy_counter
always @ (count)
	begin
		if (rst)
			begin
				//duty_4 <= 1'b0;
				glitchy_counter <= 7'b0000000;
				start <= 1'b0;
			end
		else if ((start == 1) && (count == 0))
			begin
				//duty_4 <= ~duty_4;
				glitchy_counter <= glitchy_counter - 5; 
			end
		else
			begin
				glitchy_counter <= glitchy_counter + 2;
				start <= 1'b1;
			end
	end

//count clock cycles
always @ (posedge clk_in)
	begin
		if (rst)
				count <= 2'b00;
		else
				count <= count + 1'b1;
	end


endmodule
