library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity pic16femu is

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

			statusout : out std_logic_vector(7 downto 0);
			statusin : in std_logic_vector(7 downto 0);
			
			rxdata : in std_logic_vector(7 downto 0);
			line_ptr : out std_logic_vector(7 downto 0);
			
			txdata : out std_logic_vector(7 downto 0);
			
			in_distance_0 : in std_logic_vector(7 downto 0);
			in_distance_1 : in std_logic_vector(7 downto 0);
			in_distance_2 : in std_logic_vector(7 downto 0);
			in_distance_3 : in std_logic_vector(7 downto 0);
			in_distance_4 : in std_logic_vector(7 downto 0);
			in_distance_5 : in std_logic_vector(7 downto 0);
			in_distance_6 : in std_logic_vector(7 downto 0);
			in_distance_7 : in std_logic_vector(7 downto 0);
			in_angle_0 : in std_logic_vector(7 downto 0);
			in_angle_1 : in std_logic_vector(7 downto 0);
			in_angle_2 : in std_logic_vector(7 downto 0);
			in_angle_3 : in std_logic_vector(7 downto 0);
			in_angle_4 : in std_logic_vector(7 downto 0);
			in_angle_5 : in std_logic_vector(7 downto 0);
			in_angle_6 : in std_logic_vector(7 downto 0);
			in_angle_7 : in std_logic_vector(7 downto 0);

			
			-- for debug(shimo)
		  debug_ram_out : out std_logic_vector(31 downto 0)

			);
	
end pic16femu;

architecture RTL of pic16femu is

	signal Q : std_logic;
	signal cmd : std_logic_vector(13 downto 0); -- [instruction code]
	signal adr : std_logic_vector(12 downto 0); -- [adress of program memory]
	signal fosc : std_logic; -- [clock from prescaler module]
	signal reset : std_logic; -- [reset signal from reset module]
	signal cmd_freq : std_logic; -- [command for clear instruction code from command processor]
	signal cmd_flash : std_logic; -- [command for clear instruction code to program memory]
	signal wr_pc : std_logic; -- [writing flag for modify program counter]
	signal pc_in : std_logic_vector(12 downto 0); -- [signal (adress) to program counter]
	signal wr_tmr : std_logic; -- [writing flag for modify timer0]
	signal tim_out : std_logic_vector(7 downto 0); -- [signal from timer0 module]
	signal opt : std_logic_vector(7 downto 0); -- [signal from file register (option register)]
	signal wr_wreg : std_logic; -- [writing flag for modify working regster]
	signal wreg : std_logic_vector(7 downto 0); -- [working regster]
	signal db_in : std_logic_vector(7 downto 0); -- [data bus from file register module]
	signal db_out : std_logic_vector(7 downto 0); -- [data bus from ALU module]
	signal cin : std_logic; -- [carry (in)]
	signal cout : std_logic; -- [carry (out)]
	signal dc : std_logic; -- [digit carry]
	signal zf : std_logic; -- [zero flag]
	signal wr_fr : std_logic; -- [writing flag for modify file register]
	signal wr_cf : std_logic; -- [writing flag for modify carry]
	signal wr_dc : std_logic; -- [writing flag for modify digit carry]
	signal wr_zf : std_logic; -- [writing flag for modify zero flag]
	signal cmd_skip : std_logic; -- [command for clear instruction code]
	signal w_portain : std_logic_vector(7 downto 0); -- [same as signal from porta]
	signal w_portbin : std_logic_vector(7 downto 0); -- [same as signal from portb]
	signal w_portcin : std_logic_vector(7 downto 0); -- [same as signal from portc]
	signal w_portdin : std_logic_vector(7 downto 0); -- [same as signal from portd]
	signal w_portein : std_logic_vector(7 downto 0); -- [same as signal from porte]
	signal w_portaout : std_logic_vector(7 downto 0); -- [same as signal to porta]
	signal w_portbout : std_logic_vector(7 downto 0); -- [same as signal to portb]
	signal w_portcout : std_logic_vector(7 downto 0); -- [same as signal to portc]
	signal w_portdout : std_logic_vector(7 downto 0); -- [same as signal to portd]
	signal w_porteout : std_logic_vector(7 downto 0); -- [same as signal to porte]
	signal lite : std_logic_vector(7 downto 0); -- [literal signal]
	signal clkout	: std_logic; -- [for 4MHz operation]
	
	component mprescaler
		port(
			CLK50 : in std_logic;
			CLK4	: out std_logic
			);
	end component;


	component mReset
	
		port(
			clk : in std_logic;
			resw : in std_logic;
			reset  : out std_logic
			);
	
	end component;
	
	component mTmgGen
		
		port(
			reset : in std_logic;
			clk : in std_logic;
			sw : in std_logic;
			Qout : out std_logic
			);
	end component;
	
	component mplogmem

		port(
			fosc : in std_logic;
			reset : in std_logic;
			adr : in std_logic_vector(12 downto 0);
			dat : out std_logic_vector(13 downto 0);
			Q : in std_logic;
			cmdClr : in std_logic
			);

	end component;

	component mCmdProc
		
		port(
			cmd : in std_logic_vector(13 downto 0);
			cmd_flash : out std_logic
			);

	end component;
	
	component mPCounter
		port(
			reset : in std_logic;
			clk : in std_logic;
			Q : in std_logic;
			cmd : in std_logic_vector(13 downto 0);
			wr_pc : in std_logic;
			wr_dat : in std_logic_vector(12 downto 0);
			adr : out std_logic_vector(12 downto 0)
			);
	end component;

	component mTimer0
	
		port(
			reset : in std_logic;
			clk : in std_logic;
			Q : in std_logic;
			opt : in std_logic_vector(3 downto 0);
			wr_timer : in std_logic;
			datin : in std_logic_vector(7 downto 0);
			datout : out std_logic_vector(7 downto 0)
			);

	end component;
	
	component mWreg
		
		port(
			reset : in std_logic;
			clk : in std_logic;
			Q : in std_logic;
			write0 : in std_logic;
			datin : in std_logic_vector(7 downto 0);
			datout : out std_logic_vector(7 downto 0)
		);
	
	end component;

	component mALU

		port(
			cmd	:in std_logic_vector(13 downto 0);
			wreg	:in std_logic_vector(7 downto 0);
			datin	:in std_logic_vector(7 downto 0);
			cin		:in std_logic;
			datout	:out std_logic_vector(7 downto 0);
			cout	:out std_logic;
			dc		:out std_logic;
			zf		:out std_logic;
			wr_f	:out std_logic;
			wr_w	:out std_logic;
			wr_c	:out std_logic;
			wr_dc	:out std_logic;
			wr_zf	:out std_logic;
			lite	:out std_logic_vector(7 downto 0);
			cmd_skip:out std_logic
			);
	end component;

	component mRegFile

		port(
			reset : in std_logic;
			clk : in std_logic;
			Q : in std_logic;
			fadr : in std_logic_vector(6 downto 0);
			datin : in std_logic_vector(7 downto 0);
			datout : out std_logic_vector(7 downto 0);
		   cin : in std_logic;
			cout : out std_logic;
			dc : in std_logic;
			zf : in std_logic;
			wr_cf : in std_logic;
			wr_dc : in std_logic;
			wr_zf : in std_logic;
			wr_fr : in std_logic;
			porta_in : in std_logic_vector(7 downto 0);
			portb_in : in std_logic_vector(7 downto 0);
			portc_in : in std_logic_vector(7 downto 0);
			portd_in : in std_logic_vector(7 downto 0);
			porte_in : in std_logic_vector(7 downto 0);
			porta_out : out std_logic_vector(7 downto 0);
			portb_out : out std_logic_vector(7 downto 0);
			portc_out : out std_logic_vector(7 downto 0);
			portd_out : out std_logic_vector(7 downto 0);
			porte_out : out std_logic_vector(7 downto 0);
			pc_in : in std_logic_vector(12 downto 0);
			pc_out : out std_logic_vector(12 downto 0);
			wr_pc : out std_logic;
			timer_in : in std_logic_vector(7 downto 0);
			wr_tmr : out std_logic;
			opt_out : out std_logic_vector(7 downto 0);
			cmd	:in std_logic_vector(13 downto 0);
			
			txdata : out std_logic_vector(7 downto 0);
			
			statusin	: in std_logic_vector(7 downto 0);
			statusout : out std_logic_vector(7 downto 0);

			rxdata : in std_logic_vector(7 downto 0);
			line_ptr : out std_logic_vector(7 downto 0);
			
			in_distance_0 : in std_logic_vector(7 downto 0);
			in_distance_1 : in std_logic_vector(7 downto 0);
			in_distance_2 : in std_logic_vector(7 downto 0);
			in_distance_3 : in std_logic_vector(7 downto 0);
			in_distance_4 : in std_logic_vector(7 downto 0);
			in_distance_5 : in std_logic_vector(7 downto 0);
			in_distance_6 : in std_logic_vector(7 downto 0);
			in_distance_7 : in std_logic_vector(7 downto 0);
			in_angle_0 : in std_logic_vector(7 downto 0);
			in_angle_1 : in std_logic_vector(7 downto 0);
			in_angle_2 : in std_logic_vector(7 downto 0);
			in_angle_3 : in std_logic_vector(7 downto 0);
			in_angle_4 : in std_logic_vector(7 downto 0);
			in_angle_5 : in std_logic_vector(7 downto 0);
			in_angle_6 : in std_logic_vector(7 downto 0);
			in_angle_7 : in std_logic_vector(7 downto 0);
			
  		  debug_ram_out : out std_logic_vector(31 downto 0)
			);
		end component;

begin

	-- [command for clear instraction code]
	cmd_flash <= ((cmd_freq) or (cmd_skip) or (wr_pc));

	fosc <= EXTCLK; -- [when 50 MHz operation]
	
--	fosc <= clkout; -- [when 4 MHz operation]

-- [prescaler module]
	Pres	: mprescaler port map(
							CLK50 => EXTCLK,
							CLK4	=> clkout
							);

-- [timing generater module]
	OSC2 : mTmgGen port map (
							reset => reset,
							clk => fosc,
							sw => swin,
							Qout => Q
							);

-- [reset module]	
	Rst : mReset port map (
							clk => fosc,
						   resw => resw,
						   reset => reset
						   );
	--reset <= resw;			  
-- [program memory module]
	pmem : mplogmem port map(
							fosc => fosc,
							reset => reset,
							adr => adr,
							dat => cmd,
							Q => Q,
							cmdClr => cmd_flash
							 );
							 
	Cproc : mCmdProc port map (
							cmd => cmd,
							cmd_flash => cmd_freq
							);

-- [program counter module]
	PC0 : mPCounter port map (
							reset => reset,
							clk => fosc,
							Q => Q,
							cmd => cmd,
							wr_pc => wr_pc,
							wr_dat => pc_in,
							adr => adr
							);

-- [timer0 module]						 
	tmr0 : mTimer0 port map (
							reset => reset,
							clk => fosc,
							Q => Q,
							opt => opt(3 downto 0),
							wr_timer => wr_tmr,
							datin => db_out,
							datout => tim_out
							);

-- [working register module]
	w_reg : mWreg port map (
							reset => reset,
							clk => fosc,
							Q => Q,
							write0 => wr_wreg,
							datin => db_out,
							datout => wreg
							);

-- [ALU module]
	alu : mALU port map(
							cmd		=> cmd,
							wreg	=> wreg,
							datin	=> db_in,
							cin		=> cin,
							datout	=> db_out,
							cout	=> cout,
							dc		=> dc,
							zf		=> zf,
							wr_f	=> wr_fr,
							wr_w	=> wr_wreg,
							wr_c	=> wr_cf,
							wr_dc	=> wr_dc,
							wr_zf	=> wr_zf,
							lite  => lite,
							cmd_skip=> cmd_skip
							);

-- [file register module]	
	regfile : mRegFile port map (
							reset => reset,
							clk => fosc, 
							Q => Q,
							fadr => cmd(6 downto 0),
							datin => db_out,
							datout => db_in,
							cin => cout,
							cout => cin,
							dc => dc,
							zf => zf,
							wr_cf => wr_cf,
							wr_dc => wr_dc,
							wr_zf => wr_zf,
							wr_fr => wr_fr,
							porta_in => w_portain,
							portb_in => w_portbin,
							portc_in => w_portcin,
							portd_in => w_portdin,
							porte_in => w_portein,
							porta_out => w_portaout,
							portb_out => w_portbout,
							portc_out => w_portcout,
							portd_out => w_portdout,
							porte_out => w_porteout,
							pc_in => adr,
							pc_out => pc_in,
							wr_pc => wr_pc,
							timer_in => tim_out,
							wr_tmr => wr_tmr,
							opt_out => opt,
							cmd => cmd(13 downto 0),
							
							txdata => txdata,
							
							statusin => statusin,
							statusout => statusout,
							
							rxdata => rxdata,
							line_ptr => line_ptr,
							
							in_distance_0 => in_distance_0,
							in_distance_1 => in_distance_1,
							in_distance_2 => in_distance_2,
							in_distance_3 => in_distance_3,
							in_distance_4 => in_distance_4,
							in_distance_5 => in_distance_5,
							in_distance_6 => in_distance_6,
							in_distance_7 => in_distance_7,
							in_angle_0 => in_angle_0,
							in_angle_1 => in_angle_1,
							in_angle_2 => in_angle_2,
							in_angle_3 => in_angle_3,
							in_angle_4 => in_angle_4,
							in_angle_5 => in_angle_5,
							in_angle_6 => in_angle_6,
							in_angle_7 => in_angle_7,

						 
						 debug_ram_out => debug_ram_out
							);

	w_portain <= portain;
	w_portbin <= portbin;
	w_portcin <= portcin;
	w_portdin <= portdin;
	w_portein <= portein;
	portaout <= w_portaout;
	portbout <= w_portbout;
	portcout <= w_portcout;
	portdout <= w_portdout;
	porteout <= w_porteout;

end RTL;