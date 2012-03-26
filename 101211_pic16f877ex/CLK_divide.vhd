----------------------------------------------------------------------------------
-- Company: Sasebo National Collage of Technology
-- Engineer: Kosei Shimoo
-- 
-- Create Date:    21:01:38 06/09/2007 
-- Design Name: 
-- Module Name:    CLK_divide - Behavioral 
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

entity CLK_divide is
	generic(
		cvalue	: std_logic_vector(31 downto 0) := X"00000A2C" --when 50MHz => 9600bps
	);
	port(
		CLK		: in std_logic; --50MHz 20ns
		RST		: in std_logic;
		DIVCLK	: out std_logic
		);
end CLK_divide;

architecture Behavioral of CLK_divide is

signal count	: std_logic_vector(31 downto 0):=(others=>'0');
signal i_DIVCLK	: std_logic := '0';

begin

	DIVCLK <= i_DIVCLK;
	
	process(RST, i_DIVCLK, CLK) begin
		if(RST='1') then
			count <= X"00000000";
			i_DIVCLK <= '0';
		elsif(CLK'event and CLK='1') then
			if(count=cvalue) then
				count <= X"00000000";
				i_DIVCLK <= not i_DIVCLK;
			else
				count <= count + '1';
			end if;
		end if;
	end process;
	
end Behavioral;

