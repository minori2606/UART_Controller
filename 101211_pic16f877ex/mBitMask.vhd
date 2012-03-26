library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mBitMask is

	port(
			bitin	:in std_logic_vector(2 downto 0);
			mask	:out std_logic_vector(7 downto 0));
end mBitMask;

architecture RTL of mBitMask is

	signal maskdat	:std_logic_vector(7 downto 0);

begin

	mask <= maskdat;

	process (bitin) begin
		case (bitin) is
			when "000" => maskdat <= "00000001";
			when "001" => maskdat <= "00000010";
			when "010" => maskdat <= "00000100";
			when "011" => maskdat <= "00001000";
			when "100" => maskdat <= "00010000";
			when "101" => maskdat <= "00100000";
			when "110" => maskdat <= "01000000";
			when others => maskdat <= "10000000";
		end case;
	end process;
end RTL;