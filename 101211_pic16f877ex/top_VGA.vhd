----------------------------------------------------------------------------------
-- Company: Sasebo National College of Technology
-- Engineer: Kosei Shimoo
-- 
-- Create Date:    17:14:51 12/05/2010 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top_PICVGA is
    Port (
			  CLK : in std_logic;
			  VGA_RED : out  STD_LOGIC;
           VGA_GREEN : out  STD_LOGIC;
           VGA_BLUE : out  STD_LOGIC;
           VGA_HSYNC : out  STD_LOGIC;
           VGA_VSYNC : out  STD_LOGIC);
end top_PICVGA;

architecture Behavioral of top_PICVGA is

signal CLK25MHz : std_logic:= '0';
signal count : std_logic_vector(11 downto 0) := X"000";
signal Vcount : std_logic_vector(11 downto 0) := X"000";

begin

	-- Generate 25MHz
	process(CLK) begin
		if(CLK'event and CLK='1') then
			CLK25MHz <= not CLK25MHz;
		end if;
	end process;

	process(CLK25MHz) begin
		if(CLK25MHz'event and CLK25MHz='1') then
			if(count=X"320") then
				count <= X"000";
			else
				count <= count + '1';
			end if;
		end if;
	end process;

	process(CLK25MHz) begin
		if(CLK25MHz'event and CLK25MHz='1') then
			if(Vcount=X"209") then
				Vcount <= X"000";
			elsif(count=X"320") then
				Vcount <= Vcount + '1';			
			end if;
		end if;
	end process;

	process(CLK25MHz) begin
		if(CLK25MHz'event and CLK25MHz='1') then
			if(count<=X"290") then
				VGA_HSYNC <= '1';
			elsif(count<=X"2F0") then
				VGA_HSYNC <= '0';				
			else
				VGA_HSYNC <= '1';
			end if;
		end if;
	end process;

	process(CLK25MHz) begin
		if(CLK25MHz'event and CLK25MHz='1') then
			if(Vcount<=X"1EA") then
				VGA_VSYNC <= '1';
			elsif(Vcount<=X"1EC") then
				VGA_VSYNC <= '0';				
			else
				VGA_VSYNC <= '1';
			end if;
		end if;
	end process;

	process(CLK25MHz) begin
		if(CLK25MHz'event and CLK25MHz='1') then
			if(Vcount<=X"F0") then
			if(count<=X"050") then
				VGA_RED <= '1';
				VGA_GREEN <= '1';
				VGA_BLUE <= '1';
			elsif(count<=X"0A0") then
				VGA_RED <= '1';
				VGA_GREEN <= '1';
				VGA_BLUE <= '0';
			elsif(count<=X"0F0") then
				VGA_RED <= '0';
				VGA_GREEN <= '1';
				VGA_BLUE <= '1';
			elsif(count<=X"140") then
				VGA_RED <= '0';
				VGA_GREEN <= '1';
				VGA_BLUE <= '0';
			elsif(count<=X"190") then
				VGA_RED <= '1';
				VGA_GREEN <= '0';
				VGA_BLUE <= '1';
			elsif(count<=X"1E0") then
				VGA_RED <= '1';
				VGA_GREEN <= '0';
				VGA_BLUE <= '0';
			elsif(count<=X"230") then
				VGA_RED <= '0';
				VGA_GREEN <= '0';
				VGA_BLUE <= '1';
			elsif(count<=X"280") then
				VGA_RED <= '0';
				VGA_GREEN <= '0';
				VGA_BLUE <= '0';
			else
				VGA_RED <= '0';
				VGA_GREEN <= '0';
				VGA_BLUE <= '0';
			end if;
			else
			if(count<=X"050") then
				VGA_RED <= '0';
				VGA_GREEN <= '0';
				VGA_BLUE <= '0';
			elsif(count<=X"0A0") then
				VGA_RED <= '0';
				VGA_GREEN <= '0';
				VGA_BLUE <= '1';
			elsif(count<=X"0F0") then
				VGA_RED <= '1';
				VGA_GREEN <= '0';
				VGA_BLUE <= '0';
			elsif(count<=X"140") then
				VGA_RED <= '1';
				VGA_GREEN <= '0';
				VGA_BLUE <= '1';
			elsif(count<=X"190") then
				VGA_RED <= '0';
				VGA_GREEN <= '1';
				VGA_BLUE <= '0';
			elsif(count<=X"1E0") then
				VGA_RED <= '0';
				VGA_GREEN <= '1';
				VGA_BLUE <= '1';
			elsif(count<=X"230") then
				VGA_RED <= '1';
				VGA_GREEN <= '1';
				VGA_BLUE <= '0';
			elsif(count<=X"280") then
				VGA_RED <= '1';
				VGA_GREEN <= '1';
				VGA_BLUE <= '1';
			else
				VGA_RED <= '0';
				VGA_GREEN <= '0';
				VGA_BLUE <= '0';
			end if;
			end if;
		end if;
	end process;

end Behavioral;

