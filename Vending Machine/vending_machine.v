`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:06:52 05/23/2020 
// Design Name: 
// Module Name:    vending_machine 
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
module vending_machine(
    input CARD_IN,
    input VALID_TRAN,
    input [3:0] ITEM_CODE,
    input KEY_PRESS,
    input DOOR_OPEN,
    input RELOAD,
    input CLK,			//system clock - 10ns
    input RESET,
    output reg VEND,
    output reg INVALID_SEL,
    output reg FAILED_TRAN,
    output reg [2:0] COST
    );

//global variables for vending machine states
parameter reset_state = 3'b000;
parameter reload_state = 3'b001;
parameter idle_state = 3'b010;
parameter transact_state = 3'b011;
parameter vend_state = 3'b100;
//extra helper states
parameter getcode_state = 3'b101;
parameter valid_state = 3'b110;
parameter door_state = 3'b111;

//registers for current and next states
reg [2:0] CURR_STATE;
reg [2:0] NEXT_STATE;

//CLOCK COUNTER
reg [2:0] CYCLES_T;  //transact
reg [2:0] CYCLES_G;  //getcode
reg [2:0] CYCLES_D;  //door

//registers for GETCODE 0-9
reg [1:0] NUMDIGITS;
reg [4:0] ITEM;
reg DONE;

//register for door_toggle
reg TOGGLE;
reg OPEN;
reg NO_DOOR;

//20 x 4 bit counters
reg [3:0] COUNT_00;
reg [3:0] COUNT_01;
reg [3:0] COUNT_02;
reg [3:0] COUNT_03;
reg [3:0] COUNT_04;
reg [3:0] COUNT_05;
reg [3:0] COUNT_06;
reg [3:0] COUNT_07;
reg [3:0] COUNT_08;
reg [3:0] COUNT_09;
reg [3:0] COUNT_10;
reg [3:0] COUNT_11;
reg [3:0] COUNT_12;
reg [3:0] COUNT_13;
reg [3:0] COUNT_14;
reg [3:0] COUNT_15;
reg [3:0] COUNT_16;
reg [3:0] COUNT_17;
reg [3:0] COUNT_18;
reg [3:0] COUNT_19;

// always block to update state : sequential - triggered by clock
//on reset, set to initial state (idle)
always @(posedge CLK)
	begin
		if (RESET == 1)
			CURR_STATE <= reset_state;
		else
			CURR_STATE <= NEXT_STATE;
	end

//clock counters
always @ (posedge CLK)
	begin
		if (CURR_STATE == getcode_state)
			begin
				//reset counter if key pressed
				if (KEY_PRESS)
					CYCLES_G <= 3'b000;
				//else increment
				else
					CYCLES_G <= CYCLES_G + 1'b1;
			end
		else if (CURR_STATE == transact_state)
			begin
				CYCLES_G <= 3'b000;
				//if valid trans, reset counter
				if (VALID_TRAN)
					CYCLES_T <= 3'b000;
				//else increment
				else
					CYCLES_T <= CYCLES_T + 1'b1;
			end
		else if (CURR_STATE == door_state)
			begin
				CYCLES_T <= 3'b000;
				//if the door has been opened, dont count
				if (DOOR_OPEN | OPEN)
					CYCLES_D <= 3'b000;
				//else increment
				else
					CYCLES_D <= CYCLES_D + 1'b1;
			end
		else
			begin
				//dont count
				CYCLES_T <= 3'b000;
				CYCLES_D <= 3'b000;
				CYCLES_G <= 3'b000;
			end
	end
	
//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------

// always block to decide next_state : combinational- triggered by state/input
always @(*)
begin
	case(CURR_STATE)
		reset_state : begin
				//set nextstate = idle
				NEXT_STATE = idle_state;
					end
		reload_state: begin
				//set nextstate = idle
				NEXT_STATE = idle_state;
					end
		idle_state: begin
				//only state where a reload can occur
				if (RELOAD)
					NEXT_STATE = reload_state;
				//if card is input, begin transaction
				else if (CARD_IN)
					NEXT_STATE = getcode_state;
				//else remain idle
				else
					NEXT_STATE = idle_state;
					end
		getcode_state: begin
				//correctly got item
				if (DONE)
					NEXT_STATE = valid_state;
				//getcode failed
				else if (CYCLES_G == 3'b110) 
					NEXT_STATE = idle_state;
				//card must stay inserted
				else if (CARD_IN == 0)
					NEXT_STATE = idle_state;
				//stay in state
				else
					NEXT_STATE = getcode_state; 
					end
		valid_state: begin
				//move onto transact_state
				NEXT_STATE = transact_state;
					end
		transact_state: begin
				//invalid selection
				if (INVALID_SEL)
					NEXT_STATE = idle_state;
				//valid transaction
				else if (VALID_TRAN)
					NEXT_STATE = vend_state;
				//no response in 5 cycles
				else if (FAILED_TRAN)
					NEXT_STATE = idle_state;
				//else stay in state
				else
					NEXT_STATE = transact_state;
					end
		vend_state: begin
				//move onto door opening state
				NEXT_STATE = door_state;
					end
		door_state: begin
				//if door has opened and closed
				if (TOGGLE)
					NEXT_STATE = idle_state;
				//door doesnt open in time
				else if (NO_DOOR)
					NEXT_STATE = idle_state;
				//else wait
				else
					NEXT_STATE = door_state;
					end
	endcase
end

//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------

//always block to decide outputs : triggered by state/inputs; can be comb/seq.
always @(*)
begin
	case(CURR_STATE)
		reset_state: begin
				//set all outputs and counters to 0
				//outputs
				VEND = 1'b0;
				INVALID_SEL = 1'b0;
				FAILED_TRAN = 1'b0;
				COST = 3'b000;
				//variables
				NUMDIGITS = 2'b00;
				ITEM = 5'b00000;
				TOGGLE = 1'b0;
				NO_DOOR = 1'b0;
				OPEN = 1'b0;
				DONE = 1'b0;
				//counters
				COUNT_00 = 4'b0000;
				COUNT_01 = 4'b0000;
				COUNT_02 = 4'b0000;
				COUNT_03 = 4'b0000;
				COUNT_04 = 4'b0000;
				COUNT_05 = 4'b0000;
				COUNT_06 = 4'b0000;
				COUNT_07 = 4'b0000;
				COUNT_08 = 4'b0000;
				COUNT_09 = 4'b0000;
				COUNT_10 = 4'b0000;
				COUNT_11 = 4'b0000;
				COUNT_12 = 4'b0000;
				COUNT_13 = 4'b0000;
				COUNT_14 = 4'b0000;
				COUNT_15 = 4'b0000;
				COUNT_16 = 4'b0000;
				COUNT_17 = 4'b0000;
				COUNT_18 = 4'b0000;
				COUNT_19 = 4'b0000;
					end
		reload_state: begin
				//set all counters to 10
				COUNT_00 = 4'b1010;
				COUNT_01 = 4'b1010;
				COUNT_02 = 4'b1010;
				COUNT_03 = 4'b1010;
				COUNT_04 = 4'b1010;
				COUNT_05 = 4'b1010;
				COUNT_06 = 4'b1010;
				COUNT_07 = 4'b1010;
				COUNT_08 = 4'b1010;
				COUNT_09 = 4'b1010;
				COUNT_10 = 4'b1010;
				COUNT_11 = 4'b1010;
				COUNT_12 = 4'b1010;
				COUNT_13 = 4'b1010;
				COUNT_14 = 4'b1010;
				COUNT_15 = 4'b1010;
				COUNT_16 = 4'b1010;
				COUNT_17 = 4'b1010;
				COUNT_18 = 4'b1010;
				COUNT_19 = 4'b1010;
					end
		idle_state: begin
				//all outputs = 0
				VEND = 1'b0;
				INVALID_SEL = 1'b0;
				FAILED_TRAN = 1'b0;
				COST = 3'b000;
				//variables
				NUMDIGITS = 2'b00;
				ITEM = 5'b00000;
				TOGGLE = 1'b0;
				NO_DOOR = 1'b0;
				OPEN = 1'b0;
				DONE = 1'b0;
					end
		getcode_state: begin
				//check if 5 cycles have elapsed
				if (CYCLES_G == 3'b110)
					INVALID_SEL = 1;
				else if (KEY_PRESS)
					begin
						//increment number of digits and item value
						if (NUMDIGITS == 1'b0)
							begin
								NUMDIGITS = 1'b1;
								if (ITEM_CODE == 1)
									ITEM = 5'b01010;
								else if (ITEM_CODE == 0)
									ITEM = 5'b00000;
								else
									ITEM = 5'b10100;
							end
						//second digit
						else if (NUMDIGITS == 1'b1)
							begin
								NUMDIGITS = 2'b10;
								ITEM = ITEM + ITEM_CODE;
								DONE = 1'b1;
							end
					end
					end
		valid_state: begin
				//check if seletion valid
				//if valid, update cost
				if (ITEM > 19)
					INVALID_SEL = 1'b1;
				else if (ITEM > 17)
					begin
						if ((ITEM == 19) && (COUNT_19 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 18) && (COUNT_18 == 0))
							INVALID_SEL = 1'b1;
						else
							COST = 3'b110;
					end
				else if (ITEM > 15)
					begin
						if ((ITEM == 17) && (COUNT_17 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 16) && (COUNT_16 == 0))
							INVALID_SEL = 1'b1;
						else
							COST = 3'b101;
					end
				else if (ITEM > 11)
					begin
						if ((ITEM == 15) && (COUNT_15 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 14) && (COUNT_14 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 13) && (COUNT_13 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 12) && (COUNT_12 == 0))
							INVALID_SEL = 1'b1;
						else
							COST = 3'b100;
					end
				else if (ITEM > 7)
					begin
						if ((ITEM == 11) && (COUNT_11 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 10) && (COUNT_10 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 9) && (COUNT_09 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 8) && (COUNT_08 == 0))
							INVALID_SEL = 1'b1;
						else
							COST = 3'b011;
					end
				else if (ITEM > 3)
					begin
						if ((ITEM == 7) && (COUNT_07 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 6) && (COUNT_06 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 5) && (COUNT_05 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 4) && (COUNT_04 == 0))
							INVALID_SEL = 1'b1;
						else
							COST = 3'b010;
					end
				else if (ITEM > -1)
					begin
						if ((ITEM == 3) && (COUNT_03 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 2) && (COUNT_02 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 1) && (COUNT_01 == 0))
							INVALID_SEL = 1'b1;
						else if ((ITEM == 0) && (COUNT_00 == 0))
							INVALID_SEL = 1'b1;
						else
							COST = 3'b001;
					end
				else
					INVALID_SEL = 1'b1;
					end
		transact_state: begin
				//wait for 5 cycles
				if (CYCLES_T == 3'b110)
					FAILED_TRAN = 1'b1;
					end				
		vend_state: begin
				//set VEND to 1
				VEND = 1;
				//decrease counter for item by 1
				case(ITEM)
					0: begin
						COUNT_00 = COUNT_00 - 1'b1;
						end
					1: begin
						COUNT_01 = COUNT_01 - 1'b1;
						end
					2: begin
						COUNT_02 = COUNT_02 - 1'b1;
						end
					3: begin
						COUNT_03 = COUNT_03 - 1'b1;
						end
					4: begin
						COUNT_04 = COUNT_04 - 1'b1;
						end
					5: begin
						COUNT_05 = COUNT_05 - 1'b1;
						end
					6: begin
						COUNT_06 = COUNT_06 - 1'b1;
						end
					7: begin
						COUNT_07 = COUNT_07 - 1'b1;
						end
					8: begin
						COUNT_08 = COUNT_08 - 1'b1;
						end
					9: begin
						COUNT_09 = COUNT_09 - 1'b1;
						end
					10: begin
						COUNT_10 = COUNT_10 - 1'b1;
						end
					11: begin
						COUNT_11 = COUNT_11 - 1'b1;
						end
					12: begin
						COUNT_12 = COUNT_12 - 1'b1;
						end
					13: begin
						COUNT_13 = COUNT_13 - 1'b1;
						end
					14: begin
						COUNT_14 = COUNT_14 - 1'b1;
						end
					15: begin
						COUNT_15 = COUNT_15 - 1'b1;
						end
					16: begin
						COUNT_16 = COUNT_16 - 1'b1;
						end
					17: begin
						COUNT_17 = COUNT_17 - 1'b1;
						end
					18: begin
						COUNT_18 = COUNT_18 - 1'b1;
						end
					19: begin
						COUNT_19 = COUNT_19 - 1'b1;
						end
				endcase
					end
		door_state: begin
				//check it hasn't been too long
				if ((OPEN == 0) && (CYCLES_D == 3'b110))
					NO_DOOR = 1'b1;
				else 
					begin
						//if door has been opened, set flag
						if (DOOR_OPEN)
								OPEN = 1'b1;
						//if it has been opened and now is closed, door toggled
						else if ((OPEN) && (DOOR_OPEN == 1'b0))
								TOGGLE = 1'b1;
					end
					end
	endcase
end

endmodule
