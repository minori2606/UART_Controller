library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity UART_Controller is
	port(
			clk : in std_logic;
			reset : in std_logic;
			rx : in std_logic;
			aps_status : in std_logic;
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
			debug_ram_out : out std_logic_vector(31 downto 0);
			
			tx : out std_logic
			
	);

end UART_Controller ;

architecture RTL of UART_Controller is

component pic16femu is
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
			
			txdata : out std_logic_vector(7 downto 0);

			statusin : in std_logic_vector(7 downto 0);
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
			
			-- for debug(shimo)
		  debug_ram_out : out std_logic_vector(31 downto 0)

			);
end component;

component uart_rx is
	port (
			clk        : in std_logic;
			reset      : in std_logic;
			rx         : in std_logic;
			line_ptr : in std_logic_vector(7 downto 0);
			line_out : out std_logic_vector(7 downto 0);
			data_out   : out std_logic_vector(7 downto 0);
			out_valid  : out std_logic;
			line_rcv : out std_logic
			);
end component;

component uart_tx is
	port (
			clk        : in std_logic;
			reset      : in std_logic;
			data_in   : in std_logic_vector(7 downto 0);
			in_valid  : in  std_logic;
			
			accept_in : out std_logic;
			tx         : out std_logic
			);
end component;

signal i_rxdata : std_logic_vector(7 downto 0);
signal status_pout : std_logic_vector(7 downto 0) := X"00";
signal status_pin : std_logic_vector(7 downto 0) := X"00";
signal i_line_ptr : std_logic_vector(7 downto 0);
signal i_line_out : std_logic_vector(7 downto 0);
signal i_txdata : std_logic_vector(7 downto 0);

begin

PIC : pic16femu
		port map(
			 EXTCLK => clk,
			swin => '1',
			resw => '0',
			portain => X"00",
			portbin => X"00",
			portcin => X"00",
			portdin => X"00",
			portein => X"00",
			portaout => open,
			portbout => open,
			portcout => open,
			portdout => open,
			porteout => open,
			
			txdata => i_txdata,

			statusin => status_pin,
			statusout => status_pout,
			
			rxdata => i_line_out,
			line_ptr => i_line_ptr,
			
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
			
			
			-- for debug(shimo)
		  debug_ram_out => debug_ram_out

		);

RX0 : uart_rx
		port map(
			clk => clk,
			reset => reset,
			rx => rx,
			line_ptr => i_line_ptr,
			line_out => i_line_out,
			line_rcv => status_pin(5),
			data_out => i_rxdata,
			out_valid => status_pin(4)
		);
		
TX0 : uart_tx
		port map(
			clk => clk,
			reset => reset,
			data_in => i_txdata,
			in_valid => status_pout(5),
			accept_in => status_pin(6),
			tx => tx
		);

end RTL;