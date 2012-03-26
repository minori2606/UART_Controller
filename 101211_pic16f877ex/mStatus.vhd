library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mStatus is

	port(
			reset	:in std_logic;
			clk	:in std_logic;
			Q		:in std_logic;
			-- [each writing flag]
			wr_zf	:in std_logic;
			wr_dc	:in std_logic;
			wr_cf	:in std_logic;
			wr_fr	:in std_logic;
			
			zf		:in std_logic; -- [zero flag]
			dc		:in std_logic; -- [digit carry]
			cf		:in std_logic; -- [carry]
			wr_rps:in std_logic; -- [writing flag for bank change(set instruction)]
			wr_rpc:in std_logic; -- [writing flag for bank change(clear instruction)]
			rp0	:in std_logic; -- [siganl for bank change]
			rp1	:in std_logic; -- [signal for bank change]
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0)
			);
end mStatus;

architecture RTL of mStatus is

	signal streg	:std_logic_vector(7 downto 0); -- [same as datout]

begin

	datout <= streg;

	process (clk,reset) begin
		if (clk'event and clk='1') then
			if (reset='1') then
				streg <= "00011000";
			elsif (Q='1') then
				if (wr_fr='1') then -- [process when modify all status register]
					streg <= datin;
				else
					if (wr_zf='1') then -- [process when modify zero flag]
						streg(2) <= zf;
					end if;
					if (wr_dc='1') then -- [process when modify digit carry flag]
						streg(1) <= dc;
					end if;
					if (wr_cf='1') then -- [process when modify carry flag]
						streg(0) <= cf;
					end if;
					if (wr_rps='1') then -- [process when modify zero flag (set instruction)]
						streg(6 downto 5) <= streg(6 downto 5) or (RP1 & RP0);
					end if;
					if (wr_rpc='1') then -- [process when modify zero flag (clear instruction)]
						streg(6 downto 5) <= streg(6 downto 5) and (not (RP1 & RP0));
					end if;
				end if;
			end if;
		end if;
	end process;
end RTL;


