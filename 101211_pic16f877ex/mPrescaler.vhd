----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:51:39 09/01/2009 
-- Design Name: 
-- Module Name:    mPrescaler - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mPrescaler is
    Port ( CLK50 : in  STD_LOGIC; -- [50 MHz clock]
           CLK4 : out  STD_LOGIC  -- [4  MHz clock]
			  );
end mPrescaler;

architecture Behavioral of mPrescaler is

signal counter	:	std_logic_vector(4 downto 0) := "00000";
signal clkout	:	std_logic := '0';

begin

	CLK4 <= clkout; -- [For 4 MHz emu (l_45-72)]

	process (CLK50) begin
		if (CLK50'event and CLK50 = '0') then
			counter <= counter + '1';
			if (counter="00101") then
				clkout  <= '1';
			elsif (counter="01011") then
				clkout <= '0';
			elsif (counter = "10001") then
				clkout  <= '1';
			elsif (counter = "11000") then
				clkout <= '0';
				counter <= "00000";
			end if;
		end if;
	end process;
	
end Behavioral;

