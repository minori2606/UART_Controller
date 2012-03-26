library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mGpio is

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_gpio	:in std_logic;
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0));
end mGpio;

architecture RTL of mGpio is

	signal gpreg	:std_logic_vector(7 downto 0);

begin

	datout <= gpreg;

	process (clk,reset) begin
		if (clk'event and clk='1') then
			if (reset='1') then
				gpreg <= "00000000";
			elsif (Q='1') then
				if (wr_gpio='1') then
					gpreg <= datin;
				end if;
			end if;
		end if;
	end process;
end RTL;