----------------------------------------------------------------------------------
-- Company: Sasebo National College of Technology
-- Engineer: Kosei Shimoo
-- 
-- Create Date:    15:03:42 08/22/2009 
-- Design Name: 
-- Module Name:    top_PICLCD - Behavioral 
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
use work.LCD_PAC.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_PICLCD is
	port(
		CLK : in std_logic; -- 50MHz
		E : out std_logic;
		RS : out std_logic;
		RW : out std_logic;
		DB : out std_logic_vector(7 downto 4);
		SF_CE0 : out std_logic;	-- for SPARTAN-3E evaluation board setting only
--		
--		PC_PIC	: in std_logic_vector(15 downto 0); -- Program Counter from PIC
--		INST_PIC	: in std_logic_vector(31 downto 0); -- INSTruction from PIC
--		REG1_PIC : in std_logic_vector(15 downto 0); -- REGister x2 from PIC
		REG2_PIC : in std_logic_vector(31 downto 0) -- REGister x4 from PIC
	);
end top_PICLCD;

architecture Behavioral of top_PICLCD is
component LCDdriver
	Port ( 
		CLK : in STD_LOGIC; -- 50MHz
		RW : out  STD_LOGIC;
		E : out  STD_LOGIC;
		RS : out  STD_LOGIC;
		DB : out  STD_LOGIC_VECTOR (7 downto 4);
		
		LCD_DATA1 : in STD_LOGIC_VECTOR (31 downto 0);
		LCD_DATA2 : in STD_LOGIC_VECTOR (31 downto 0);
		LCD_DATA3 : in STD_LOGIC_VECTOR (31 downto 0);
		LCD_DATA4 : in STD_LOGIC_VECTOR (31 downto 0);
		LCD_ROW : out STD_LOGIC
		);
end component;

component btoa
	port(
		OSC			: in std_logic;
		START			: in std_logic;
		ASCII_OK		: out std_logic;
		BINARY_IN	: in std_logic_vector(12 downto 0);
		ASCII_OUT	: out std_logic_vector(31 downto 0)
	);
end component;

component htoa
	port(
		hex_in	: in std_logic_vector(7 downto 0);
		hex_out	: out std_logic_vector(15 downto 0)
	);
end component;

-- instruction to ascii-code
component insttoa
	port(
		INST_PIC : in std_logic_vector(31 downto 0);
		INST_ASC : out std_logic_vector(47 downto 0)
	);
end component;

signal LCD_DATA1 : std_logic_vector(31 downto 0);
signal LCD_DATA2 : std_logic_vector(31 downto 0);
signal LCD_DATA3 : std_logic_vector(31 downto 0);
signal LCD_DATA4 : std_logic_vector(31 downto 0);
signal LCD_ROW : std_logic;

signal cnt : std_logic_vector(31 downto 0):=X"00000000";
signal osc1Hz : std_logic;
signal cnt1Hz : std_logic_vector(12 downto 0):= '0' & X"000";
signal start : std_logic:='0';
signal ascii_time : std_logic_vector(31 downto 0);

signal ch_PC	: std_logic_vector(31 downto 0);
signal ch_REG1	: std_logic_vector(15 downto 0);
signal ch_REG2	: std_logic_vector(15 downto 0);
signal ch_REG3	: std_logic_vector(15 downto 0);
signal ch_REG4	: std_logic_vector(15 downto 0);
signal ch_REG5	: std_logic_vector(15 downto 0);
signal ch_REG6	: std_logic_vector(15 downto 0);
signal ch_INST	: std_logic_vector(47 downto 0);

---------- for DEMO MODE ---------
signal		PC_PIC	: std_logic_vector(15 downto 0); -- Program Counter from PIC
signal		INST_PIC	: std_logic_vector(31 downto 0):=X"00000001"; -- INSTruction from PIC
signal		REG1_PIC : std_logic_vector(15 downto 0); -- REGister x2 from PIC
--signal		REG2_PIC : std_logic_vector(31 downto 0); -- REGister x4 from PIC
---------- for DEMO MODE ---------

begin

	SF_CE0 <= '1';
	
	process(LCD_ROW) begin
		if(LCD_ROW='0') then -- first ROW
			LCD_DATA1 <= ch_PC;
			LCD_DATA2 <= ch_INST(47 downto 16);
			LCD_DATA3 <= ch_INST(15 downto 0) & ch_space & ch_REG1(15 downto 8);
			LCD_DATA4 <= ch_REG1(7 downto 0) & ch_space & ch_REG2;
		else -- second ROW
			LCD_DATA1 <= ch_REG3 & ch_space & ch_space;
			LCD_DATA2 <= ch_REG4 & ch_space & ch_space;
			LCD_DATA3 <= ch_REG5 & ch_space & ch_space;
			LCD_DATA4 <= ch_REG6 & ch_space & ch_space;
		end if;
	end process;

	MHtoA00: htoa port map(PC_PIC(15 downto 8), ch_PC(31 downto 16));
	MHtoA01: htoa port map(PC_PIC(7 downto 0), ch_PC(15 downto 0));

	MHtoA0: htoa port map(REG1_PIC(15 downto 8), ch_REG1);
	MHtoA1: htoa port map(REG1_PIC(7 downto 0), ch_REG2);
	MHtoA2: htoa port map(REG2_PIC(31 downto 24), ch_REG3);
	MHtoA3: htoa port map(REG2_PIC(23 downto 16), ch_REG4);
	MHtoA4: htoa port map(REG2_PIC(15 downto 8), ch_REG5);
	MHtoA5: htoa port map(REG2_PIC(7 downto 0), ch_REG6);

	MItoA : insttoa port map(INST_PIC, ch_INST);

	M0: LCDdriver port map(CLK => CLK, RW => RW, E => E, RS => RS,
		DB => DB, LCD_DATA1 => LCD_DATA1, LCD_DATA2 => LCD_DATA2,
		LCD_DATA3 => LCD_DATA3, LCD_DATA4 => LCD_DATA4,
		LCD_ROW => LCD_ROW);

	---------- DEMO MODE ----------

	PC_PIC <= "000" & cnt1Hz;
	process(OSC1HZ) begin
		if(OSC1HZ'event and OSC1HZ='1') then
			INST_PIC <= INST_PIC(30 downto 0) & INST_PIC(31);
		end if;
	end process;
	REG1_PIC <= X"35AF";
--	REG2_PIC <= INST_PIC;

	-- Timer Part --
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(cnt=X"017D7840") then -- 1s(1Hz)
--			if(cnt=X"002625A0") then -- 0.1s(10Hz)
				cnt <= X"00000000";
			else
				cnt <= cnt + '1';
			end if;
		end if;
	end process;

	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(cnt=X"017D7840") then -- 1s(1Hz)
--			if(cnt=X"002625A0") then -- 0.1s(10Hz)
				osc1Hz <= not osc1Hz;
			end if;
		end if;
	end process;

	process(osc1Hz) begin
		if(osc1Hz'event and osc1Hz='1') then
			cnt1Hz <= cnt1Hz + '1';
		end if;
	end process;


	-- binary to ascii part
	M1: btoa
	port map(
		OSC => CLK,
		START => start,
		ASCII_OK => open,
		BINARY_IN => cnt1Hz,
		ASCII_OUT => ascii_time
	);

	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(cnt=X"00000000") then
				start <= '1';
			else
				start <= '0';
			end if;
		end if;
	end process;

end Behavioral;

