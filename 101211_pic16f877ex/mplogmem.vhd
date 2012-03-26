library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mplogmem is
    Port ( fosc : in  STD_LOGIC; -- [same as the clock]
           reset : in  STD_LOGIC;
           adr : in  STD_LOGIC_VECTOR (12 downto 0); -- [adress of program memory]
           Q : in  STD_LOGIC;
           cmdClr : in  STD_LOGIC; -- [instruction that clears adress]
           dat : out  STD_LOGIC_VECTOR (13 downto 0) -- [instruction code]
			  );
end mplogmem;

architecture Behavioral of mplogmem is

	signal dbus	:std_logic_vector(15 downto 0);
	signal abus : std_logic_vector(15 downto 0);

component mFlashMem -- [program made ROM]
	port( adr : in  STD_LOGIC_VECTOR (15 downto 0);
			dat : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

begin

	abus <= "000" & adr;

	process (fosc,reset) begin
		if (reset='1') then
			dat <= "00000000000000";
		elsif (fosc'event and fosc='1') then
			if (Q='1') then
				if (cmdClr='1') then
					dat <= "00000000000000";
				else -- [usual operation]
					dat <= dbus(13 downto 0);
				end if;
			end if;
		end if;
	end process;

	fmem: mFlashMem port map (
										adr => abus, -- [adress of program memory]
										dat => dbus -- [instruction code]
										);

end Behavioral;
