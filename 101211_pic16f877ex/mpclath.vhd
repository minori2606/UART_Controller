library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mpclath is

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_pclath	:in std_logic;
			datin	:in std_logic_vector(4 downto 0);
			datout	:out std_logic_vector(4 downto 0));
end mpclath;

architecture RTL of mpclath is

	signal pclathreg	:std_logic_vector(4 downto 0);

begin

	datout <= pclathreg;

	process (clk,reset) begin
		if (clk'event and clk='1') then
			if (reset='1') then
				pclathreg <= "00000";
			elsif (Q='1') then
				if (wr_pclath='1') then
					pclathreg <=datin;
				end if;
			end if;
		end if;
	end process;
end RTL;