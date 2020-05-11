----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:53:15 05/09/2020 
-- Design Name: 
-- Module Name:    clock_div_two - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_div_two is
    Port ( clk_in : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk_div_2 : out  STD_LOGIC;
           clk_div_4 : out  STD_LOGIC;
           clk_div_8 : out  STD_LOGIC;
           clk_div_16 : out  STD_LOGIC);
end clock_div_two;

architecture Behavioral of clock_div_two is

begin


end Behavioral;

