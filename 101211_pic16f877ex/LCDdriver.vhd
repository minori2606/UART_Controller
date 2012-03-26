----------------------------------------------------------------------------------
-- Company: Sasebo National College of Technology
-- Engineer: Kosei Shimoo
-- 
-- Create Date:    15:13:14 08/22/2009 
-- Design Name: 
-- Module Name:    LCDdriver - Behavioral 
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

entity LCDdriver is
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
end LCDdriver;

architecture Behavioral of LCDdriver is

signal cnt : std_logic_vector(31 downto 0) := X"00000000";
signal init_end: std_logic;
signal i_DB: std_logic_vector(7 downto 4);
signal i_E, i_RW, i_RS: std_logic;

signal wcnt : std_logic_vector(11 downto 0) := X"000";
signal w_DB : std_logic_vector(7 downto 4);
signal w_E, w_RW, w_RS: std_logic;
signal wdata : std_logic_vector(7 downto 0);

signal wdcnt : std_logic_vector(7 downto 0);
signal wd_stop : std_logic;

begin
	
	---------- LCD initialize part ----------
		-- LCD initialize counter
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(init_end='1') then
				cnt <= cnt;
			else
				cnt <= cnt + '1';
			end if;
		end if;
	end process;

	-- LCD initialize command
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(cnt >= X"B71B0" and cnt <= X"B71BC") then -- after 750,000
				i_DB <= X"3"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"E9284" and cnt <= X"E9290") then -- after 205,000
				i_DB <= X"3"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"EA618" and cnt <= X"EA624") then -- after 5,000
				i_DB <= X"3"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"EADF4" and cnt <= X"EAE00") then -- after 2,000
				i_DB <= X"2"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"EBDA0" and cnt <= X"EBDAC") then --fset1
				i_DB <= X"2"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';			
			elsif(cnt >= X"EBDB1" and cnt <= X"EBDBD") then --fset2
				i_DB <= X"8"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"EC58D" and cnt <= X"EC599") then --ems1
				i_DB <= X"0"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"EC59E" and cnt <= X"EC5AA") then --ems2
				i_DB <= X"6"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"ECD7A" and cnt <= X"ECD86") then --doo1
				i_DB <= X"0"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"ECD8B" and cnt <= X"ECD97") then --doo2
				i_DB <= X"F"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"ED567" and cnt <= X"ED573") then --cd1
				i_DB <= X"0"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			elsif(cnt >= X"ED578" and cnt <= X"ED584") then --cd2
				i_DB <= X"1"; i_E <= '1'; i_RW <= '0'; i_RS <= '0';
			else
				i_DB <= X"0"; i_E <= '0'; i_RW <= '1'; i_RS <= '1';
			end if;
		end if;
	end process;

	--LCD initialize end signal
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(cnt >= X"1015D4") then
				init_end <= '1';
			else
				init_end <= '0';
			end if;
		end if;
	end process;
	---------- LCD initialize part ----------

	---------- LCD write part ----------
	-- Write Cycle Counter
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(init_end='0' or wcnt = X"7ED" or wd_stop='1') then  -- 12+5+12+2000=X"7ED"
				wcnt <= X"000";
			else
				wcnt <= wcnt + '1';
			end if;
		end if;
	end process;
	
	process(wcnt, wdata) begin
		if(wcnt>=X"001" and wcnt<=X"00D") then -- 12cycle
			w_DB <= wdata(7 downto 4); -- upper 4bits
			w_E <= '1';
			w_RW <= '0';
			if(wdata=X"80" or wdata=X"C0") then -- When Set DD RAM Address RS=1
				w_RS <= '0';
			else -- Write Data to DD RAM
				w_RS <= '1';
			end if;
		elsif(wcnt>=X"012" and wcnt<=X"01E") then -- 12cycle
			w_DB <= wdata(3 downto 0); -- lower 4bits
			w_E <= '1';
			w_RW <= '0';
			if(wdata=X"80" or wdata=X"C0") then  --  When Set DD RAM Address RS=1
				w_RS <= '0';
			else -- Write Data to DD RAM
				w_RS <= '1';
			end if;
		else
			w_DB <= X"0";
			w_E <= '0';
			w_RW <= '0';
			w_RS <= '0';		
		end if;
	end process;
	---------- LCD write part ----------

	process(init_end, w_DB, w_E, w_RW, w_RS, i_DB, i_E, i_RW, i_RS) begin
		if(init_end='1') then
			DB <= w_DB;
			E <= w_E;
			RW <= w_RW;
			RS <= w_RS;
		else
			DB <= i_DB;
			E <= i_E;
			RW <= i_RW;
			RS <= i_RS;
		end if;
	end process;

	---------- LCD test display part ----------
	process(wdcnt, LCD_DATA1,  LCD_DATA2,  LCD_DATA3,  LCD_DATA4) begin
		if(wdcnt=X"000" or wdcnt=X"022") then
			wdata <= X"80";
		elsif(wdcnt=X"001" or wdcnt=X"012") then
			wdata <= LCD_DATA1(31 downto 24);
		elsif(wdcnt=X"002" or wdcnt=X"013") then
			wdata <= LCD_DATA1(23 downto 16);
		elsif(wdcnt=X"003" or wdcnt=X"014") then
			wdata <= LCD_DATA1(15 downto 8);
		elsif(wdcnt=X"004" or wdcnt=X"015") then
			wdata <= LCD_DATA1(7 downto 0);
		elsif(wdcnt=X"005" or wdcnt=X"016") then
			wdata <= LCD_DATA2(31 downto 24);
		elsif(wdcnt=X"006" or wdcnt=X"017") then
			wdata <= LCD_DATA2(23 downto 16);
		elsif(wdcnt=X"007" or wdcnt=X"018") then
			wdata <= LCD_DATA2(15 downto 8);
		elsif(wdcnt=X"008" or wdcnt=X"019") then
			wdata <= LCD_DATA2(7 downto 0);
		elsif(wdcnt=X"009" or wdcnt=X"01A") then
			wdata <= LCD_DATA3(31 downto 24);
		elsif(wdcnt=X"00A" or wdcnt=X"01B") then
			wdata <= LCD_DATA3(23 downto 16);
		elsif(wdcnt=X"00B" or wdcnt=X"01C") then
			wdata <= LCD_DATA3(15 downto 8);
		elsif(wdcnt=X"00C" or wdcnt=X"01D") then
			wdata <= LCD_DATA3(7 downto 0);
		elsif(wdcnt=X"00D" or wdcnt=X"01E") then
			wdata <= LCD_DATA4(31 downto 24);
		elsif(wdcnt=X"00E" or wdcnt=X"01F") then
			wdata <= LCD_DATA4(23 downto 16);
		elsif(wdcnt=X"00F" or wdcnt=X"020") then
			wdata <= LCD_DATA4(15 downto 8);
		elsif(wdcnt=X"010" or wdcnt=X"021") then
			wdata <= LCD_DATA4(7 downto 0);
		elsif(wdcnt=X"011") then
			wdata <= X"C0";
		else
			wdata <= X"FF";
		end if;
	end process;

	process(wdcnt) begin
		if(wdcnt<=X"011") then
			LCD_ROW <= '0';
		else
			LCD_ROW <= '1';
		end if;
	end process;

	process(wdcnt) begin
		if(wdcnt=X"22") then
			wd_stop <= '0';
		else
			wd_stop <= '0';
		end if;
	end process;

	-- Write Data Counter
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(wdcnt = X"22") then
				wdcnt <= X"00";
			elsif(wcnt = X"7ED") then
				wdcnt <= wdcnt + '1';
			end if;
		end if;
	end process;

end Behavioral;
