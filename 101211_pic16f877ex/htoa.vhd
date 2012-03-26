----------------------------------------------------------------------------------
-- Company: Sasebo National College of Technology
-- Engineer: 
-- 
-- Create Date:    14:23:21 09/26/2009 
-- Design Name: 
-- Module Name:    htoa - Behavioral 
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
use work.LCD_PAC.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity htoa is
	port(
		hex_in	: in std_logic_vector(7 downto 0);
		hex_out	: out std_logic_vector(15 downto 0)
	);
end htoa;

architecture Behavioral of htoa is

begin

	process(hex_in) begin
		case hex_in(3 downto 0) is
			when X"0" => hex_out(7 downto 0) <= ch_0;
			when X"1" => hex_out(7 downto 0) <= ch_1;
			when X"2" => hex_out(7 downto 0) <= ch_2;
			when X"3" => hex_out(7 downto 0) <= ch_3;
			when X"4" => hex_out(7 downto 0) <= ch_4;
			when X"5" => hex_out(7 downto 0) <= ch_5;
			when X"6" => hex_out(7 downto 0) <= ch_6;
			when X"7" => hex_out(7 downto 0) <= ch_7;
			when X"8" => hex_out(7 downto 0) <= ch_8;
			when X"9" => hex_out(7 downto 0) <= ch_9;
			when X"A" => hex_out(7 downto 0) <= ch_a;
			when X"B" => hex_out(7 downto 0) <= ch_b;
			when X"C" => hex_out(7 downto 0) <= ch_c;
			when X"D" => hex_out(7 downto 0) <= ch_d;
			when X"E" => hex_out(7 downto 0) <= ch_e;
			when X"F" => hex_out(7 downto 0) <= ch_f;
			when others => hex_out(7 downto 0) <= ch_blank;
		end case;
	end process;

	process(hex_in) begin
		case hex_in(7 downto 4) is
			when X"0" => hex_out(15 downto 8) <= ch_0;
			when X"1" => hex_out(15 downto 8) <= ch_1;
			when X"2" => hex_out(15 downto 8) <= ch_2;
			when X"3" => hex_out(15 downto 8) <= ch_3;
			when X"4" => hex_out(15 downto 8) <= ch_4;
			when X"5" => hex_out(15 downto 8) <= ch_5;
			when X"6" => hex_out(15 downto 8) <= ch_6;
			when X"7" => hex_out(15 downto 8) <= ch_7;
			when X"8" => hex_out(15 downto 8) <= ch_8;
			when X"9" => hex_out(15 downto 8) <= ch_9;
			when X"A" => hex_out(15 downto 8) <= ch_a;
			when X"B" => hex_out(15 downto 8) <= ch_b;
			when X"C" => hex_out(15 downto 8) <= ch_c;
			when X"D" => hex_out(15 downto 8) <= ch_d;
			when X"E" => hex_out(15 downto 8) <= ch_e;
			when X"F" => hex_out(15 downto 8) <= ch_f;
			when others => hex_out(15 downto 8) <= ch_blank;
		end case;
	end process;

end Behavioral;

