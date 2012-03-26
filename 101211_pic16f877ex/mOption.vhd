library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mOption is

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_opt	:in std_logic;
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0));
end mOption;

architecture RTL of mOption is

	signal optreg	:std_logic_vector(7 downto 0);

begin

	datout <= optreg;

	process (clk,reset) begin
		if (clk'event and clk='1') then
			if (reset='1') then
				optreg <= "11111111";
			elsif (Q='1') then
				if (wr_opt='1') then
					optreg <= datin;
				end if;
			end if;
		end if;
	end process;
end RTL;