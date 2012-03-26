----------------------------------------------------------------------------------
-- Company: Kosei Shimoo
-- Engineer: Sasebo National College of Technology
-- 
-- Create Date:    10:23:58 12/06/2010 
-- Design Name: 
-- Module Name:    spartan3e_eval_board - Behavioral 
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
use work.RS232C_PAC.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spartan3e_eval_board is
	port(
		-- Pushbuttons (BTN)
		BTN_EAST : in std_logic;
		BTN_NORTH : in std_logic;
		BTN_SOUTH : in std_logic;
		BTN_WEST : in std_logic;

		-- Clock inputs (CLK)
		CLK_50MHZ : in std_logic;

		-- 6-pin header (J1,J2,J4)
		J1 : inout std_logic_vector(3 downto 0);
		J2 : inout std_logic_vector(3 downto 0);
		J4 : inout std_logic_vector(3 downto 0);

		-- Character LCD (LCD)
		LCD_E : out std_logic;
		LCD_RS : out std_logic;
		LCD_RW : out std_logic;
		SF_D : out std_logic_vector(11 downto 8);
		SF_CE0 : out std_logic;

		-- Discrete LEDs (LED)
		LED : out std_logic_vector(7 downto 0);
		
		-- RS-232 Serial Ports (RS232)
		RS232_DCE_RXD : in std_logic;
		RS232_DCE_TXD : out std_logic;
		RS232_DTE_RXD : in std_logic;
		RS232_DTE_TXD : out std_logic;

		-- Slide Switches (SW)
		SW : in std_logic_vector(3 downto 0);
		
		-- VGA Port (VGA)
		VGA_BLUE : out std_logic;
		VGA_GREEN : out std_logic;
		VGA_RED : out std_logic;
		VGA_HSYNC : out std_logic;
		VGA_VSYNC : out std_logic
	);
end spartan3e_eval_board;

architecture Behavioral of spartan3e_eval_board is

component pic16femu
	port( EXTCLK	: in std_logic;
			swin : in std_logic;
			resw			: in std_logic;
			-- [each port]
			portain		: in std_logic_vector(7 downto 0);
			portbin		: in std_logic_vector(7 downto 0);
			portcin		: in std_logic_vector(7 downto 0);
			portdin		: in std_logic_vector(7 downto 0);
			portein		: in std_logic_vector(7 downto 0);
			portaout		: out std_logic_vector(7 downto 0);
			portbout		: out std_logic_vector(7 downto 0);
			portcout		: out std_logic_vector(7 downto 0);
			portdout		: out std_logic_vector(7 downto 0);
			porteout		: out std_logic_vector(7 downto 0);
			
		  ext_data_in1 : in std_logic_vector(7 downto 0);
		  ext_data_in2 : in std_logic_vector(7 downto 0);
		  
			-- for debug(shimo)
		  debug_ram_out : out std_logic_vector(31 downto 0)
			
			);
end component;

component top_PICLCD
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
end component;

component top_PICVGA
    Port (
			  CLK : in std_logic;
			  VGA_RED : out  STD_LOGIC;
           VGA_GREEN : out  STD_LOGIC;
           VGA_BLUE : out  STD_LOGIC;
           VGA_HSYNC : out  STD_LOGIC;
           VGA_VSYNC : out  STD_LOGIC);
end component;

signal debug_ram_out : std_logic_vector(31 downto 0);
signal gp_in : std_logic_vector(7 downto 0);
signal gp_out : std_logic_vector(7 downto 0);
signal gp_osc : std_logic; 
signal tris_out : std_logic_vector(7 downto 0); 
signal GPIO : std_logic_vector(7 downto 0);

component TxD_driver
	port(
		OSC	: in std_logic;	-- sample 50MHz
		TxD	: out std_logic;
		ASCII_IN	: in std_logic_vector(7 downto 0);
		READY	: out std_logic -- next ascii-code ready (pulse)
	);
end component;

signal READY_cnt : std_logic_vector(7 downto 0):=X"00";
signal ASCII_IN : std_logic_vector(7 downto 0):=X"00";
signal READY : std_logic:='0';

component measure_distance
	port(
		CLK : in std_logic;
		data : out std_logic_vector(15 downto 0)
	);
end component;

signal ext_data_in : std_logic_vector(15 downto 0);
signal BTN_NEWS : std_logic_vector(7 downto 0);

begin

	M_MD : measure_distance port map(
		CLK => CLK_50MHZ,
		data => ext_data_in
	);

BTN_NEWS <= BTN_NORTH & BTN_EAST & BTN_WEST & BTN_SOUTH & BTN_NORTH & BTN_EAST & BTN_WEST & BTN_SOUTH;

	M_PIC : pic16femu port map(
		EXTCLK => CLK_50MHZ,
		swin => SW(0),
		resw => SW(1),
		portain => BTN_NEWS,
		portbin => BTN_NEWS,
		portcin => BTN_NEWS,
		portdin => BTN_NEWS,
		portein => BTN_NEWS,
		portaout => open,
		portbout => open,
		portcout => open,
		portdout => open,
		porteout => open,
		ext_data_in1 => ext_data_in(7 downto 0),
		ext_data_in2 => ext_data_in(15 downto 8),
		debug_ram_out => debug_ram_out
	);

	M_LCD : top_PICLCD port map(
		CLK => CLK_50MHZ,
		E => LCD_E,
		RS => LCD_RS,
		RW => LCD_RW,
		DB => SF_D(11 downto 8),
		SF_CE0 => SF_CE0,
--		
--		PC_PIC	: in std_logic_vector(15 downto 0); -- Program Counter from PIC
--		INST_PIC	: in std_logic_vector(31 downto 0); -- INSTruction from PIC
--		REG1_PIC : in std_logic_vector(15 downto 0); -- REGister x2 from PIC
		REG2_PIC => debug_ram_out
		);

	M_VGA : top_PICVGA port map(
		CLK => CLK_50MHZ,
		VGA_RED => VGA_RED,
		VGA_GREEN => VGA_GREEN,
		VGA_BLUE => VGA_BLUE,
		VGA_HSYNC => VGA_HSYNC,
		VGA_VSYNC => VGA_VSYNC
		);
	
	RS232_DTE_TXD <= '0';

	LED <= debug_ram_out(7 downto 0);

	J2 <= GPIO(7 downto 4);
	J1 <= GPIO(3 downto 0);

	process (gp_osc,tris_out,gp_out) begin
		if (tris_out(0) = '1') then
			GPIO(0) <= 'Z';
--			gp_in(0) <= GPIO(0);
		else
			GPIO(0) <= gp_out(0);
		end if;
	end process;

	process (gp_osc,tris_out,gp_out) begin
		if (tris_out(1) = '1') then
			GPIO(1) <= 'Z';
--			gp_in(1) <= GPIO(1);
		else
			GPIO(1) <= gp_out(1);
		end if;
	end process;

	process (gp_osc,tris_out,gp_out) begin
		if (tris_out(2) = '1') then
			GPIO(2) <= 'Z';
--			gp_in(2) <= GPIO(2);
		else
			GPIO(2) <= gp_out(2);
		end if;
	end process;

	process (gp_osc,tris_out,gp_out) begin
		if (tris_out(3) = '1') then
			GPIO(3) <= 'Z';
--			gp_in(3) <= GPIO(3);
		else
			GPIO(3) <= gp_out(3);
		end if;
	end process;

	process (gp_osc,tris_out,gp_out)begin
		if (tris_out(4) = '1') then
			GPIO(4) <= 'Z';
--			gp_in(4) <= GPIO(4);
		else
			GPIO(4) <= gp_out(4);
		end if;
	end process;

	process (gp_osc,tris_out,gp_out) begin
		if (tris_out(5) = '1') then
			GPIO(5) <= 'Z';
--			gp_in(5) <= GPIO(5);
		else
			GPIO(5) <= gp_out(5);
		end if;
	end process;

	process (gp_osc,tris_out,gp_out) begin
		if (tris_out(6) = '1') then
			GPIO(6) <= 'Z';
--			gp_in(6) <= GPIO(6);
		else
			GPIO(6) <= gp_out(6);
		end if;
	end process;

	process (gp_osc,tris_out,gp_out) begin
		if (tris_out(7) = '1') then
			GPIO(7) <= 'Z';
--			gp_in(7) <= GPIO(7);
		else
			GPIO(7) <= gp_out(7);
		end if;
	end process;

--	gp_in <= GPIO;
	gp_in <= GPIO(7 downto 1) & BTN_SOUTH;

	M0: TxD_driver
		port map(
			OSC => CLK_50MHZ,
			TxD => RS232_DCE_TXD,
			ASCII_IN	=> ASCII_IN,
			READY	=> READY
		);

	process(READY) begin
		if(READY'event and READY='1') then
			if(READY_cnt=X"1F") then
				READY_cnt <= X"00";
			else
				READY_cnt <= READY_cnt + '1';
			end if;
		end if;
	end process;

	process(READY_cnt) begin
		case READY_cnt is 
			when X"00" => ASCII_IN <= ch_cT;
			when X"01" => ASCII_IN <= ch_h;
			when X"02" => ASCII_IN <= ch_i;
			when X"03" => ASCII_IN <= ch_s;
			when X"04" => ASCII_IN <= ch_space;
			when X"05" => ASCII_IN <= ch_i;
			when X"06" => ASCII_IN <= ch_s;
			when X"07" => ASCII_IN <= ch_space;
			when X"08" => ASCII_IN <= ch_cR;
			when X"09" => ASCII_IN <= ch_cS;
			when X"0A" => ASCII_IN <= ch_2;
			when X"0B" => ASCII_IN <= ch_3;
			when X"0C" => ASCII_IN <= ch_2;
			when X"0D" => ASCII_IN <= ch_cC;
			when X"0E" => ASCII_IN <= ch_cCR;
			when X"0F" => ASCII_IN <= ch_cLF;

			when X"10" => ASCII_IN <= ch_0;
			when X"11" => ASCII_IN <= ch_1;
			when X"12" => ASCII_IN <= ch_2;
			when X"13" => ASCII_IN <= ch_3;
			when X"14" => ASCII_IN <= ch_4;
			when X"15" => ASCII_IN <= ch_5;
			when X"16" => ASCII_IN <= ch_6;
			when X"17" => ASCII_IN <= ch_7;
			when X"18" => ASCII_IN <= ch_8;
			when X"19" => ASCII_IN <= ch_9;
			when X"1A" => ASCII_IN <= ch_excla;
			when X"1B" => ASCII_IN <= ch_comma;
			when X"1C" => ASCII_IN <= ch_space;
			when X"1D" => ASCII_IN <= ch_blank;
			when X"1E" => ASCII_IN <= ch_cCR;
			when X"1F" => ASCII_IN <= ch_cLF;
			when others => ASCII_IN <= X"39";
		end case;
	end process;

end Behavioral;

