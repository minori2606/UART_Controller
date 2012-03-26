library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mWreg is

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			write0	:in std_logic; -- [flag for writing working register]
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0)
			);
end mWreg;

architecture RTL of mWreg is

	signal wreg	:std_logic_vector(7 downto 0); -- [same as datout]

begin

	datout <= wreg;

	process (clk,reset) begin
		if (clk'event and clk='1') then
			if (reset='1') then
				wreg <= "00000000";
			elsif (Q='1') then
				if (write0='1') then
					wreg <= datin;
				end if;
			end if;
		end if;
	end process;
end RTL;
