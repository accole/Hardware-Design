`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:42:57 06/05/2020
// Design Name:   parking_meter
// Module Name:   /home/ise/Xilinx_VM/Project5/testbench_004912373.v
// Project Name:  Project5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_004912373;

	reg [5:0] i;

	// Inputs
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;

	// Outputs
	wire a1;
	wire a2;
	wire a3;
	wire a4;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;
	wire [6:0] led_seg;

	// Instantiate the Unit Under Test (UUT)
	parking_meter meter (
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.rst(rst), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4), 
		.led_seg(led_seg)
	);
	
	//create 100Hz system clock
	always
		begin
			#5;
			clk = ~clk;
		end

	initial begin
		// Initialize Inputs
		i = 0;
		add1 = 0;  //initialize counter to 0
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;
		clk = 1;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#10;
        
		// start by getting the meter to 9999 and showing it
		// will not increase past 9999
		rst = 0;
		#50;
		//now add2 and add1 to show functionality
		add2 = 1;
		#1;
		add2 = 0;
		#5;
		add1 = 1;
		#1;
		add1 = 0;
		#53;
		for (i = 1; i < 37; i=i+1)
			begin
				add4 = 1;
				#1;
				add4 = 0;
				#10;
			end
		//next let the meter count down for 2-3 seconds, to
		//show the counter counts appropriately
		#279;
		//next push rst2, showing RST2 works, and that the
		//flashing in state1 works for 149
		rst2 = 1;
		#1;
		rst2 = 0;
		#313;
		//next push rst, resetting to 0000 and show the 
		//flashing in the reset state works properly
		rst = 1;
		#1;
		rst = 0;
		#240;
		//now add3 to demonstrate the transition from 180
		//in state2 to 179 in state1
		add3 = 1;
		#1;
		add3 = 0;
		#300;
		//now rst1, bringing counter to 15 to show the
		//0-1 transition works
		rst1 = 1;
		#1;
		rst1 = 0;
		#1700;
		//all special cases have been shown.
		$finish;
		
	end
      
endmodule

