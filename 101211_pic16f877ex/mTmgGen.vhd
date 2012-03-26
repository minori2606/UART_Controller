----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:15 07/30/2009 
-- Design Name: 
-- Module Name:    mTmgGen - Behavioral 
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

entity mTmgGen is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  sw : in std_logic;
           Qout : out  STD_LOGIC -- [Q signal]
			  );
end mTmgGen;

architecture Behavioral of mTmgGen is

	signal clkcnt	:std_logic_vector(1 downto 0):="00";
begin


-- [Q signal maker(l_46-61)]
	process (clk,reset) begin
		if (reset='1') then
			clkcnt <= "00";
		elsif (clk'event and clk='1') then
			clkcnt <= clkcnt + '1';
		end if;
	end process;
	
	process (clkcnt) begin
		if (reset = '1') then
			Qout <= '0';
		else
--			if (clkcnt(1 downto 0)="11" and sw = '1') then -- [when Q is 1/4]
--			if (clkcnt(0) = '1' and sw ='1') then -- [when Q is 1/2]
			if (sw ='1') then -- [when Q is '1']
				Qout <= '1';
			else
				Qout <= '0';
			end if;
		end if;
	end process;

end Behavioral;

