-----------------------------------------------------------
--                 UART | Transmitter Unit
-----------------------------------------------------------
--Input : clk | system clock at 1.8432 MHz
--				reset | system reset
--				in_valid | input data valid
--
--Output : tx | tx line
--					accept_in | '1' when transmitter accepts
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity uart_tx is
	port (
			clk        : in std_logic;
			reset      : in std_logic;
			data_in   : in std_logic_vector(7 downto 0);
			in_valid  : in  std_logic;
			
			accept_in : out std_logic;
			tx         : out std_logic
			);
	end entity uart_tx;


architecture behavioural of uart_tx is
	type state is (idle, reset_state, transmit_data, stop_bit);
	constant DIVCLK : std_logic_vector(11 downto 0) := X"C35";
	signal current_state, next_state : state;
	signal ticker : std_logic_vector(11 downto 0) := (others => '0');
	signal data_buffer : std_logic_vector(9 downto 0) := "1000000000";
	signal tx_state : std_logic_vector(3 downto 0) := "0000";
	signal i_clk : std_logic := '0';
	signal start_bit_flg : std_logic := '0';
	signal data_accept_flg : std_logic := '0';
begin

clkgen : process(clk, reset)
begin
	if(clk' event and clk = '1') then
			if(ticker = DIVCLK) then
				ticker <= X"000";
				i_clk <= not i_clk;
			else
				ticker <= ticker + '1';
			end if;
	end if;
	
	if(reset = '1') then
		ticker <= X"000";
		i_clk <= '0';
	end if;
end process;

--updates the statemachine at a 9600 bps rate
tx_transmit : process(i_clk, reset) 
begin
	if((current_state = idle and next_state = transmit_data) or current_state = transmit_data) then
		tx <= data_buffer(conv_integer(tx_state));
		tx_state <= tx_state + '1';
	else
		tx_state <= "0000";
		tx <= '1';
	end if;

	current_state <= next_state;
end process;

buffer_control : process(reset, in_valid)
begin
	if(in_valid = '1') then
		data_buffer(8 downto 1) <= data_in; --data bit
	end if;
	
	if(reset = '1') then
		data_buffer <= "1000000000";
	end if;
end process;

tx_control : process(i_clk, current_state)--
begin
	case current_state is
		when reset_state =>
			accept_in <= '0';
			next_state <= idle;
		
		when idle =>
			if(in_valid = '1') then
				accept_in <= '0';
				next_state <= transmit_data;
				data_accept_flg <= '1';
			elsif(data_accept_flg = '1') then
				accept_in <= '0';
			else
				next_state <= idle;
				accept_in <= '1';
			end if;
		
		when transmit_data =>
			if(tx_state < 8) then
				next_state <= transmit_data;
				accept_in <= '0';
			else
				next_state <= stop_bit;
				data_accept_flg <= '0';
				accept_in <= '0';
			end if;
		
		when stop_bit =>
			if(in_valid = '1') then
				next_state <= transmit_data;
			else
				next_state <= idle;
			end if;
			accept_in <= '1';
			
		when others =>
			accept_in <= '0';
			next_state <= reset_state;
	end case;
end process;

end architecture behavioural;
