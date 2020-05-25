`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:07:21 05/23/2020
// Design Name:   vending_machine
// Module Name:   /home/ise/Xilinx_VM/FSM/testbench_004912373.v
// Project Name:  FSM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_004912373;

	// Inputs
	reg CARD_IN;
	reg VALID_TRAN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg DOOR_OPEN;
	reg RELOAD;
	reg CLK;
	reg RESET;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire FAILED_TRAN;
	wire [2:0] COST;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CARD_IN(CARD_IN), 
		.VALID_TRAN(VALID_TRAN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.DOOR_OPEN(DOOR_OPEN), 
		.RELOAD(RELOAD), 
		.CLK(CLK), 
		.RESET(RESET), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
	);
	
	
	//creating 10ns system clock
	always
		begin
			#5;
			CLK = ~CLK;
		end

	initial begin
		// Initialize Inputs
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		CLK = 0;
		RESET = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

		//TESTCASE #1 - SUCCESSFUL TRANSACTION (SPECIAL CASE #1) RIGHT INTO ANOTHER GETCODE
		RESET = 1;  //reset the vending machine to all 0's
		#10;
		RESET = 0;  //place machine in idle state
		#10;
		RELOAD = 1; //reload the machine to full capacity
		#10;
		RELOAD = 0; //set back into idle
		#10;
		CARD_IN = 1;  //insert credit card
		#10;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b001;
		#5;
		KEY_PRESS = 0;
		#30;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b1001;  //select ITEM = 19
		#5;
		KEY_PRESS = 0;
		#40;
		VALID_TRAN = 1;  //bank sends a valid transaction bit
		#30;
		VALID_TRAN = 0;
		DOOR_OPEN = 1;  //customer opens door
		#20
		DOOR_OPEN = 0;  //customer closes door
		#50;				//machine returns to idle state, enters new transaction

		//-----------------------------------------------------------------------------
		/*
		//TESTCASE #2 - USER INPUTS 55 AS ITEMCODE
		RESET = 1;  //reset the vending machine to all 0's
		#10;
		RESET = 0;  //place machine in idle state
		#10;
		RELOAD = 1; //reload the machine to full capacity
		#10;
		RELOAD = 0; //set back into idle
		#10;
		CARD_IN = 1;  //insert credit card
		#10;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b0101;
		#5;
		KEY_PRESS = 0;
		#30;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b0101;  //select ITEM = 55
		#5;
		KEY_PRESS = 0;
		#40;
		VALID_TRAN = 1;  //bank sends a valid transaction bit
		#30;
		VALID_TRAN = 0;
		DOOR_OPEN = 1;  //customer opens door
		#20
		DOOR_OPEN = 0;  //customer closes door
		#50;				//machine returns to idle state
		*/
		
		//-----------------------------------------------------------------------------
		
		//TESTCASE #3 - DOOR IS NOT OPENED IN 5 CLOCK CYCLES
		/*
		RESET = 1;  //reset the vending machine to all 0's
		#10;
		RESET = 0;  //place machine in idle state
		#10;
		RELOAD = 1; //reload the machine to full capacity
		#10;
		RELOAD = 0; //set back into idle
		#10;
		CARD_IN = 1;  //insert credit card
		#10;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b001;
		#5;
		KEY_PRESS = 0;
		#30;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b1001;  //select ITEM = 19
		#5;
		KEY_PRESS = 0;
		#40;
		VALID_TRAN = 1;  //bank sends a valid transaction bit
		#30;
		VALID_TRAN = 0;  //customer doesn't open door
		#50;				//machine returns to idle state
		*/
		
		//-----------------------------------------------------------------------------
		
		//TESTCASE #4 - CARD REMOVED FROM MACHINE BEFORE GETCODE OVER
		/*
		RESET = 1;  //reset the vending machine to all 0's
		#10;
		RESET = 0;  //place machine in idle state
		#10;
		RELOAD = 1; //reload the machine to full capacity
		#10;
		RELOAD = 0; //set back into idle
		#10;
		CARD_IN = 1;  //insert credit card
		#10;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b001;
		#5;
		KEY_PRESS = 0;
		#30;
		CARD_IN = 0;  //customer removes card
		#10;
		KEY_PRESS = 1;
		ITEM_CODE = 4'b1001;  //select ITEM = 19
		#5;
		KEY_PRESS = 0;
		#40;
		VALID_TRAN = 1;  //bank sends a valid transaction bit
		#30;
		VALID_TRAN = 0;
		DOOR_OPEN = 1;  //customer opens door
		#20
		DOOR_OPEN = 0;  //customer closes door
		#50;				//machine returns to idle state
		*/
		
		
		//-----------------------------------------------------------------------------
		
		$finish;
		

	end
      
endmodule

