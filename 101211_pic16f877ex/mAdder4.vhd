library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mAdder4 is

	port(
			dat1	:in std_logic_vector(3 downto 0);
			dat2	:in std_logic_vector(3 downto 0);
			cin		:in std_logic;
			out0	:out std_logic_vector(3 downto 0);
			cout	:out std_logic);
end mAdder4;

architecture RTL of mAdder4 is

	signal wout	:std_logic_vector(4 downto 0);

begin

	wout <= ('0' & dat1) + ('0' & dat2) + ("0000" & cin);
	cout <= wout(4);
	out0 <= wout(3 downto 0);
end RTL;
