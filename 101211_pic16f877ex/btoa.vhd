----------------------------------------------------------------------------------
-- Company: Sasebo National College of Technology
-- Engineer: Kosei Shimoo
-- 
-- Create Date:    13:36:20 12/25/2008 
-- Design Name: 
-- Module Name:    btoa - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: binary data to ascii (0-8192) 12bit
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

entity btoa is
	port(
		OSC			: in std_logic;
		START			: in std_logic;
		ASCII_OK		: out std_logic;
		BINARY_IN	: in std_logic_vector(12 downto 0);
		ASCII_OUT	: out std_logic_vector(31 downto 0)
	);
end btoa;

architecture Behavioral of btoa is

component div
	generic(
		W : integer);
	port(
		X :in std_logic_vector(W-1 downto 0);
		Y: in std_logic_vector(W-1 downto 0);
		Q: out std_logic_vector(W-1 downto 0);
		R: out std_logic_vector(W-1 downto 0);
		CLK: in std_logic;
		START: in std_logic;
		OPEND: out std_logic);
end component;

component btoa1
	port(
		binary	: in std_logic_vector(7 downto 0);
		ascii		: out std_logic_vector(7 downto 0)
	);
end component;

constant THOUSAND	: std_logic_vector(13 downto 0):="00" & X"3E8";
constant HUNDRED	: std_logic_vector(13 downto 0):="00" & X"064";
constant TEN		: std_logic_vector(13 downto 0):="00" & X"00A";
signal i_BINARY_IN : std_logic_vector(13 downto 0):=(others => '0');
signal i_START, i_OPEND1 : std_logic:='0';
signal Q3, R3, Q2, R2, Q1, R1 : std_logic_vector(13 downto 0):=(others => '0');
signal OPEND3, OPEND2, OPEND1 : std_logic:='0';
signal asc_THOUSAND, asc_HUNDRED, asc_TEN, asc_ONE : std_logic_vector(7 downto 0):=(others => '0');
--signal asc_CNT		: std_logic_vector(7 downto 0) := X"00";
--constant asc_CR	: std_logic_vector(7 downto 0) := X"0D";
--constant asc_LF	: std_logic_vector(7 downto 0) := X"0A";
--constant asc_TAB	: std_logic_vector(7 downto 0) := X"09";

begin
	process(OSC) begin -- Flip Flop
		if(OSC'event and OSC='1') then
			i_START <= START;
			i_OPEND1 <= OPEND1;
		end if;
	end process;

	process(OSC) begin -- Flip Flop
		if(OSC'event and OSC='1') then
			if(START='1') then
				i_BINARY_IN <= '0' & BINARY_IN;
			end if;
		end if;
	end process;

	DIV3: div generic map(14) port map(i_BINARY_IN, THOUSAND, Q3, R3, OSC, i_START, OPEND3);
	DIV2: div generic map(14) port map(R3, HUNDRED, Q2, R2, OSC, OPEND3, OPEND2);
	DIV1: div generic map(14) port map(R2, TEN, Q1, R1, OSC, OPEND2, OPEND1);

	MBTOA3 : btoa1 port map(Q3(7 downto 0), asc_THOUSAND);
	MBTOA2 : btoa1 port map(Q2(7 downto 0), asc_HUNDRED);
	MBTOA1 : btoa1 port map(Q1(7 downto 0), asc_TEN); 
	MBTOA0 : btoa1 port map(R1(7 downto 0), asc_ONE);
	
	process(OSC) begin -- Flip Flop
		if(OSC'event and OSC='1') then
			if(i_OPEND1='1') then
				ASCII_OUT <= asc_THOUSAND & asc_HUNDRED & asc_TEN & asc_ONE;
			end if;
		end if;
	end process;

	ASCII_OK <= i_OPEND1;

end Behavioral;

