library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mAdder8 is

	port(
			dat1	:in std_logic_vector(7 downto 0);
			dat2	:in std_logic_vector(7 downto 0);
			cin		:in std_logic;
			out0	:out std_logic_vector(7 downto 0);
			cout	:out std_logic;
			dc		:out std_logic);
end mAdder8;

architecture RTL of mAdder8 is

component mAdder4

	port(
			dat1	:in std_logic_vector(3 downto 0);
			dat2	:in std_logic_vector(3 downto 0);
			cin		:in std_logic;
			out0	:out std_logic_vector(3 downto 0);
			cout	:out std_logic);
end component;

	signal wdc	:std_logic;

begin

	dc <= wdc;

	add4a:mAdder4 port map(
							dat1	=> dat1(3 downto 0),
							dat2	=> dat2(3 downto 0),
							cin		=> cin,
							out0	=> out0(3 downto 0),
							cout	=> wdc);

	add4b:mAdder4 port map(
							dat1	=> dat1(7 downto 4),
							dat2	=> dat2(7 downto 4),
							cin		=> wdc,
							out0	=> out0(7 downto 4),
							cout	=> cout);

end RTL;

