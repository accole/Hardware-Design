`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  UCLA
// Engineer: Adam Cole
// 
// Create Date:    01:38:07 06/05/2020 
// Design Name: 
// Module Name:    parking_meter 
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
module parking_meter(
    input add1,    //add 60
    input add2,    //add 120
    input add3,    //add 180
    input add4,    //add 300
    input rst1,    //reset time to 15
    input rst2,    //reset time to 150
    input clk,     //100 Hz input system clock = 10,000,000ns = 10ms period (toggle every 5ms)
    input rst,     //resets to initial state (0)
    output a1,     //a1 => MSB
    output a2,		 //bits for anodes (which digit on LED should display the cathode values)
    output a3,
    output a4,
    output [3:0] val1,   //val1 => a1
    output [3:0] val2,   //4-bit reps of current LED digits
    output [3:0] val3,
    output [3:0] val4,
    output [6:0] led_seg  //7 bit cathodes (which edges of digit are lit up) (led_seg[0] = Ca, led_seg[6] = Cg)
    );


//create submodule that makes T=1sec 50% duty cycle
wire clk_1sec;

// Assign this wire to our submodule
	clk_div_1s clk_one (
		.clk_in(clk), 
		.rst(rst), 
		.clk_out(clk_1sec)
	);

//create variables
reg [13:0] counter;   //time left on meter - max 9999
reg [1:0] CURR_STATE;
reg [1:0] NEXT_STATE;
wire off;					 //flashing bits
reg zero_off;
reg one_off;
reg two_off;
reg [2:0] off_count;

//states
parameter reset_state = 2'b00;  //count = 0000, T=1sec flashing
parameter state1 = 2'b01;   	  ///count < 180, T=2sec flashing, show evens
parameter state2 = 2'b10;   	  //count >= 180, T=1sec no flashing

//global constants
parameter add1val = 14'b00000000111100;  //60
parameter add2val = 14'b00000001111000;  //120
parameter add3val = 14'b00000010110100;  //180
parameter add4val = 14'b00000100101100;  //300
parameter maxval  = 14'b10011100001111;  //9999
parameter rst1val = 14'b00000000001111;  //15
parameter rst2val = 14'b00000010010110;  //150
parameter notime  = 14'b00000000000000;  //0


//make submodule that handles dec => BCD after declaring counter
	dec_to_BCD BCD (
		.count(counter), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4)
	);
	
//make a submodule for LED Controller and Anodes
	LED_controller LED (
		.clk(clk), 
		.rst(rst), 
		.off(off), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4), 
		.led_seg(led_seg)
	); 

// always block to update state : sequential - triggered by clock
//on reset, set to initial state
always @(posedge clk)
	begin
		if (rst == 1)
			CURR_STATE <= reset_state;
		else
			CURR_STATE <= NEXT_STATE;
	end

// always block to decide next_state : combinational- triggered by state/input
always @(*)
begin
	case(CURR_STATE)
		reset_state : begin
				//stay in reset state until an add button is pressed
				if (add1 || add2)  //total still <180
					NEXT_STATE = state1;
				else if (add3 || add4)  //total > 180
					NEXT_STATE = state2;
				else if (rst1 || rst2)  //either rst button pressed
					NEXT_STATE = state1;
				else     //nothing added - stay in reset
					NEXT_STATE = reset_state;
					end
		state1 : begin
				if (add1)  //adds 60 - check counter value
					begin
						if ((counter + add1val) < 180)
							NEXT_STATE = state1;
						else
							NEXT_STATE = state2;
					end
				else if (add2)  //adds 120 - check counter value
					begin
						if ((counter + add2val) < 180)
							NEXT_STATE = state1;
						else
							NEXT_STATE = state2;
					end
				else if (add3 || add4)  //total > 180 no matter what
					NEXT_STATE = state2;
				else if (rst1 || rst2)  //either rst button pressed
					NEXT_STATE = state1;
				else     //nothing added - check counter
					begin
						if (counter == notime)  //if counter hits 0
							NEXT_STATE = reset_state;
					end
					end
		state2 : begin
				if (add1 || add2 || add3 || add4)  //total > 180 no matter what
					NEXT_STATE = state2;
				else if (rst1 || rst2)  //total < 180 no matter what
					NEXT_STATE = state1;
				else     //nothing added - check counter
					begin
						if (counter < 180)
							NEXT_STATE = state1;
					end
					end
	endcase
end


//always block to update counter
always @(posedge clk_1sec or posedge rst or 
			posedge add1 or posedge add2 or 
			posedge add3 or posedge add4 or 
			posedge rst1 or posedge rst2)
begin
	if (rst)   //set counter to 0000
		counter = notime;
	else if (add1) //add 60 up to 9999
		begin
			if(CURR_STATE == reset_state)
				counter = counter + add1val;
			else   //state1 or state2
				begin
					if (counter > 9939)  //can't exceed 9999
						counter = maxval;
					else
						counter = counter + add1val;
				end
		end
	else if (add2)  //add 120 up to 9999
		begin
			if(CURR_STATE == reset_state)
				counter = counter + add2val;
			else   //state1 or state2
				begin
					if (counter > 9879)  //can't exceed 9999
						counter = maxval;
					else
						counter = counter + add2val;
				end
		end
	else if (add3)  //add 180 up to 9999
		begin
			if(CURR_STATE == reset_state)
				counter = counter + add3val;
			else   //state1 or state2
				begin
					if (counter > 9819)  //can't exceed 9999
						counter = maxval;
					else
						counter = counter + add3val;
				end
		end
	else if (add4)  //add 300 up to 9999
		begin
			if(CURR_STATE == reset_state)
				counter = counter + add4val;
			else   //state1 or state2
				begin
					if (counter > 9699)  //can't exceed 9999
						counter = maxval;
					else
						counter = counter + add4val;
				end
		end
	else if (rst1)  //reset to 15
		counter = rst1val;
	else if (rst2)  //reset to 150
		counter = rst2val;
	else 				//no buttons pushed -> posedge clk_1sec, decrease counter
		begin
			if (counter == notime)  //don't allow underflow
				counter = notime;
			else
				counter = counter - 1'b1;
		end
end


//one system cycle before clk_1sec check for off/on
always @ (posedge clk)
begin
	if (rst)  //if reset, reset counter and initialize vars
		begin
			off_count = 3'b000;
			zero_off = 0;
			one_off = 0;
		end
	else
		begin
			off_count = off_count + 3'b001; //increment counter
			if (off_count == 3'b101)   //now check for off/on
				begin
					off_count = 3'b000;  //reset counter
					case (CURR_STATE)
						reset_state : begin
							two_off = 0;
							one_off = 0;
							zero_off = ~zero_off;  //50% duty cycle
							end
						state1 : begin
							zero_off = 0;
							two_off = 0;
							if (clk_1sec == 0)
								begin
									if (val4[0] == 1)  //odd
												one_off = 0;
									else               //even
										one_off = 1;
								end
							end
						state2 : begin
							if (counter == 180)  //case for 180-179 transition
								begin
									two_off = 1;
									one_off = 1;
								end
							else
								two_off = 0;
							end
					endcase		
				end
		end
end

//always block to implement flashing dependent on state
assign off = (CURR_STATE == reset_state) ? zero_off :
				 (CURR_STATE == state1) ? one_off : two_off;

endmodule



//-----------------------------------
//Creates T=1sec 50% duty cycle
//-----------------------------------

module clk_div_1s(
    input clk_in,    //100 Hz input system clock = 10,000,000ns = 10ms period (toggle every 5ms)
	 input rst,     //reset button
    output clk_out   //50% duty cycle 1sec period clock
    );

//50% duty cycle = toggle every 0.5sec = 50ms

//create 3 bit counter and a toggle
reg start;
reg toggle;
reg [2:0] count;

always @ (posedge clk_in)  //run on clock posedge
begin
	if (rst)   //if reset
		begin
			count <= 3'b000;  //set counter to 0
			toggle <= 1'b1;
			start <= 1'b0;
		end
	else if ((start == 1) && (count == 5))   //at overflow
		begin
			count <= 3'b001;
			toggle <= ~toggle;
		end
	else    //else
		begin
			count <= count + 1'b1;   //increment counter by 1 bit
			start <= 1'b1;
		end
end

//set output clock to toggle bit
assign clk_out = toggle;

endmodule



//--------------------------------------
//Handles Decimal to BCD conversion
//--------------------------------------
module dec_to_BCD(
    input [13:0] count,    //current count
    output reg [3:0] val1, //1000's place
    output reg [3:0] val2,
    output reg [3:0] val3,
    output reg [3:0] val4  //1's place
    );
	 
	 always @ (*)
	 begin
		val1 = (count/1000);
		val2 = (count/100) - (val1*10);
		val3 = (count/10) - (val2*10) - (val1*100);
		val4 = count - (val3*10) - (val2*100) - (val1*1000);
	 end

endmodule



//--------------------------------------
//Handles LED Controller and Anodes
//--------------------------------------
module LED_controller(
    input clk,              //100Hz system clock
	 input rst,              //reset
    input off, 				 //flashing bit
	 input [3:0] val1,	    //1000's place
	 input [3:0] val2,		 //4 digits to display
	 input [3:0] val3,
	 input [3:0] val4,       //1's place
    output reg a1,
    output reg a2,              //anodes for 4 digits
    output reg a3,
    output reg a4,				  //a4 => val4
    output reg [6:0] led_seg    //cathodes for 7 seg display
    );

//create counter for anode rotation
reg [2:0] anode_count;

//global constants for LED_display
//	Num  = Ca Cb Cc Cd Ce Cf Cg
//set Ci = 0 to activate voltage
//						  abcdefg
parameter LED0 = 7'b0000001;  //only g dark
parameter LED1 = 7'b1001111;  //only b c lit
parameter LED2 = 7'b0010010;  //f and c dark
parameter LED3 = 7'b0000110;  //f and e dark
parameter LED4 = 7'b1001100;  //b c f g lit
parameter LED5 = 7'b0100100;  //b and e dark
parameter LED6 = 7'b0100000;  //all but b
parameter LED7 = 7'b0001111;  //d e f g dark
parameter LED8 = 7'b0000000;  //all set on
parameter LED9 = 7'b0000100;  //all but e


//always block to update the anodes
always @ (posedge clk)
begin
	if (rst || off)  //if reset, reset anode counter
		begin
			anode_count = 3'b000;
			a1 = 1;
			a2 = 1;     //set ai to 1 to activate voltage
			a3 = 1;
			a4 = 1;
		end
	else
		begin
			anode_count = anode_count + 3'b001;  //increment counter
			if (anode_count == 3'b001)    //val1, a1
				begin
					a1 = 0;
					a2 = 1;
					a3 = 1;
					a4 = 1;
				end
			else if (anode_count == 3'b010)    //val2, a2
				begin
					a1 = 1;
					a2 = 0;
					a3 = 1;
					a4 = 1;
				end
			else if (anode_count == 3'b011)     //val3, a3
				begin
					a1 = 1;
					a2 = 1;
					a3 = 0;
					a4 = 1;
				end
			else if (anode_count == 3'b100) 		//val4, a4
				begin
					a1 = 1;
					a2 = 1;
					a3 = 1;
					a4 = 0;
				end
			else if (anode_count == 3'b101)   //repeat val4
				begin
					a1 = 1;
					a2 = 1;
					a3 = 1;
					a4 = 0;
					anode_count = 3'b000;  //now reset
				end
		end
end


//always block to update the cathodes for the given digit
always @ (posedge clk)
begin
	if (rst)
		led_seg = LED0;
	else if (anode_count == 3'b001)  //val1, a1
		begin
			if (val1 == 0)
				led_seg = LED0;
			else if (val1 == 1)
				led_seg = LED1;
			else if (val1 == 2)
				led_seg = LED2;
			else if (val1 == 3)
				led_seg = LED3;
			else if (val1 == 4)
				led_seg = LED4;
			else if (val1 == 5)
				led_seg = LED5;
			else if (val1 == 6)
				led_seg = LED6;
			else if (val1 == 7)
				led_seg = LED7;
			else if (val1 == 8)
				led_seg = LED8;
			else
				led_seg = LED9;
		end
	else if (anode_count == 3'b010)  //val2, a2
		begin
			if (val2 == 0)
				led_seg = LED0;
			else if (val2 == 1)
				led_seg = LED1;
			else if (val2 == 2)
				led_seg = LED2;
			else if (val2 == 3)
				led_seg = LED3;
			else if (val2 == 4)
				led_seg = LED4;
			else if (val2 == 5)
				led_seg = LED5;
			else if (val2 == 6)
				led_seg = LED6;
			else if (val2 == 7)
				led_seg = LED7;
			else if (val2 == 8)
				led_seg = LED8;
			else
				led_seg = LED9;
		end
	else if (anode_count == 3'b011)  //val3, a3
		begin
			if (val3 == 0)
				led_seg = LED0;
			else if (val3 == 1)
				led_seg = LED1;
			else if (val3 == 2)
				led_seg = LED2;
			else if (val3 == 3)
				led_seg = LED3;
			else if (val3 == 4)
				led_seg = LED4;
			else if (val3 == 5)
				led_seg = LED5;
			else if (val3 == 6)
				led_seg = LED6;
			else if (val3 == 7)
				led_seg = LED7;
			else if (val3 == 8)
				led_seg = LED8;
			else
				led_seg = LED9;
		end
	else     //val4, a4
		begin
			if (val4 == 0)
				led_seg = LED0;
			else if (val4 == 1)
				led_seg = LED1;
			else if (val4 == 2)
				led_seg = LED2;
			else if (val4 == 3)
				led_seg = LED3;
			else if (val4 == 4)
				led_seg = LED4;
			else if (val4 == 5)
				led_seg = LED5;
			else if (val4 == 6)
				led_seg = LED6;
			else if (val4 == 7)
				led_seg = LED7;
			else if (val4 == 8)
				led_seg = LED8;
			else
				led_seg = LED9;
		end
end

endmodule




