library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mTimer0 is

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			opt		:in std_logic_vector(3 downto 0); -- [signal for prescaler]
			wr_timer:in std_logic; -- [flag at the writing timer0]
			datin	:in std_logic_vector(7 downto 0); -- [signal to timer0 module] 
			datout	:out std_logic_vector(7 downto 0) -- [signal to file register]
			);
end mTimer0;

architecture RTL of mTimer0 is

	signal pcount	:std_logic_vector(7 downto 0);
	signal tcount	:std_logic_vector(7 downto 0); -- [same as datout]
	signal countup	:std_logic;

begin

	datout <= tcount;

	-- [process for prescaler]
	process (opt,pcount) begin
		if ((opt(3)='1') or ((opt(2 downto 0)="000") and (pcount(0)='1'))
				or ((opt(2 downto 0)="001") and (pcount(1 downto 0)="11"))
				or ((opt(2 downto 0)="010") and (pcount(2 downto 0)="111"))
				or ((opt(2 downto 0)="011") and (pcount(3 downto 0)="1111"))
				or ((opt(2 downto 0)="100") and (pcount(4 downto 0)="11111"))
				or ((opt(2 downto 0)="101") and (pcount(5 downto 0)="111111"))
				or ((opt(2 downto 0)="110") and (pcount(6 downto 0)="1111111"))
				or ((opt(2 downto 0)="111") and (pcount(7 downto 0)="11111111"))) then
			countup <= '1';
		else
			countup <= '0';
		end if;
	end process;

	process (clk,reset) begin
		if (clk'event and clk='1') then
			if (reset='1') then
				pcount <= "00000000";
			elsif (Q='1') then
				if (wr_timer='1') then -- [process when writing timer0]
					pcount <= "00000000";
				else -- [usual operation]
					pcount <= pcount + '1';
				end if;
			end if;
		end if;
	end process;

	process (clk,reset) begin
		if (clk'event and clk='1') then
			if (reset='1') then
				tcount <= "00000000";
			else
				if (Q='1') then
					if (wr_timer='1') then -- [process when writing timer0]
						tcount <= datin;
					elsif (countup='1') then
						tcount <= tcount + '1';
					end if;
				end if;
			end if;
		end if;
	end process;
end RTL;