library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity mReset is

port(
		clk		:in std_logic;
		resw	:in std_logic; -- [reset signal from the outside]
		reset	:out std_logic); -- [reset signal to each module]

end mReset;

architecture RTL of mReset is

	signal rcnt		:std_logic:='1';
	signal cntup	:std_logic:='1';

begin

	reset	<=	rcnt;

	process (clk) begin

		if (clk'event and clk='1') then
			if (resw = '1')then
				rcnt <= '1';			
			elsif (rcnt = '1') then -- [when high-speed operation]
				rcnt <= '0';
			end if;
		end if;
	end process;
	
end RTL;