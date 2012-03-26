----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:16:07 12/25/2008 
-- Design Name: 
-- Module Name:    btoa1 - Behavioral 
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

entity btoa1 is
	port(
		binary	: in std_logic_vector(7 downto 0);
		ascii		: out std_logic_vector(7 downto 0)
	);
end btoa1;

architecture Behavioral of btoa1 is

begin
	process(binary) begin
		case binary is
			when X"00" =>
				ascii <= X"30";
			when X"01" =>
				ascii <= X"31";
			when X"02" =>
				ascii <= X"32";
			when X"03" =>
				ascii <= X"33";
			when X"04" =>
				ascii <= X"34";
			when X"05" =>
				ascii <= X"35";
			when X"06" =>
				ascii <= X"36";
			when X"07" =>
				ascii <= X"37";
			when X"08" =>
				ascii <= X"38";
			when X"09" =>
				ascii <= X"39";
			when others =>
				ascii <= X"21";
		end case;
	end process;

end Behavioral;

