-----------------------------------------------------------
--                 UART | Receiver unit
-----------------------------------------------------------
--
--
--
-----------------------------------------------------------
-- Input:      clk        | System clock at 1.8432 MHz
--             reset      | System reset
--             rx         | RX line
--
-- Output:     data_out   | Output data
--             out_valid  | Output data valid
-----------------------------------------------------------
-- uart_rx.vhd
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity uart_rx is
	port (
			clk        : in std_logic;
			reset      : in std_logic;
			rx         : in std_logic;
			line_ptr : in std_logic_vector(7 downto 0);
			data_out   : out std_logic_vector(7 downto 0);
			line_out : out std_logic_vector(7 downto 0);
			out_valid  : out std_logic;
			line_rcv : out std_logic
			);
	end entity uart_rx;


architecture behavioural of uart_rx is
	type tx_state is (reset_state, start_bit, idle, receive_data, stop_bit);
	type ram is array(0 to 255) of std_logic_vector(7 downto 0);
	signal buf : ram;
	constant DIVCLK : std_logic_vector(11 downto 0) := X"C35";
	signal current_state, next_state : tx_state;
	signal ticker : std_logic_vector(11 downto 0) := (others => '0');
	signal data_buffer : std_logic_vector(7 downto 0) := X"00";
	signal rx_filtered : std_logic := '1';
	signal rx_state : std_logic_vector(3 downto 0) := "0000";
	signal i_clk : std_logic := '0';
	signal start_bit_flg : std_logic := '0';
	signal i_line_rcv : std_logic;
	signal ptr : std_logic_vector(7 downto 0);
	signal accept_rcv : std_logic := '1';
	signal i_data_out : std_logic_vector(7 downto 0);
begin

clkgen : process(clk, reset)
begin
	if(clk' event and clk = '1') then
		if(start_bit_flg = '1' or current_state = receive_data or current_state = stop_bit or current_state = reset_state) then
			if(ticker = DIVCLK) then
				ticker <= X"000";
				i_clk <= not i_clk;
			else
				ticker <= ticker + '1';
			end if;
		else
			ticker <= X"61A";
		end if;
	end if;
	
	if(reset = '1') then
		ticker <= X"61A";
		i_clk <= '0';
	end if;
end process;

buf_control : process(clk, line_ptr)
begin
	if(current_state = stop_bit and i_line_rcv = '0') then
		if(buf(conv_integer(ptr - 1)) = X"0A" and buf(conv_integer(ptr - 2)) = X"13") then
			if(accept_rcv = '1') then
				i_line_rcv <= '1';
				accept_rcv <= '0';
			end if;
		elsif(i_data_out = X"0A") then
			i_line_rcv <= '0';
			accept_rcv <= '1';
		end if;
	elsif(i_line_rcv = '0' and accept_rcv = '0') then
		if(i_data_out = X"0A") then
			i_line_rcv <= '0';
			accept_rcv <= '1';
		else
			i_line_rcv <= '0';
			accept_rcv <= '0';
		end if;
	elsif(i_line_rcv = '1' and line_ptr /= X"FF") then
		i_line_rcv <= '1';
		accept_rcv <= '0';
		line_out <= buf(conv_integer(line_ptr));
	elsif(i_line_rcv = '1' and line_ptr = X"FF") then
			i_line_rcv <= '0';
			accept_rcv <= '0';
	else
		i_line_rcv <= '0';
		accept_rcv <= '1';
	end if;
	
	if(accept_rcv = '1') then
		buf(conv_integer(ptr)) <= data_buffer;
	end if;
	
end process;

--updates the statemachine at a 9600 bps rate
rx_receive : process(i_clk, reset) 
begin
	
	if(current_state = stop_bit) then
		data_buffer <= X"00";
		rx_state <= "0000";
	elsif(current_state = receive_data and rx_state <= 7) then
		if(rx = '1') then
			data_buffer(conv_integer(rx_state)) <= '1';
		elsif(rx = '0') then
			data_buffer(conv_integer(rx_state)) <= '0';
		end if;
		rx_state <= rx_state + '1';
	else
		--rx_state <= "0000";
	end if;

	current_state <= next_state;
end process;

rx_filter : process(rx, current_state, reset)
begin
	if(rx = '0' and current_state = idle) then
		start_bit_flg <= '1';
	elsif(rx = '1' and start_bit_flg = '1' and current_state = idle) then
		start_bit_flg <= '1';
	elsif(rx = '0' and current_state = stop_bit) then
		start_bit_flg <= '1';
	elsif(current_state = start_bit or current_state = receive_data) then
		start_bit_flg <= '1';
	else
		start_bit_flg <= '0';
	end if;
	
	if(reset = '1') then
		start_bit_flg <= '0';
	end if;
end process;

rx_control : process(i_clk, current_state, start_bit_flg)
begin
	case current_state is
		when reset_state =>
			out_valid <= '0';
			next_state <= idle;
			ptr <= X"00";
			
		when idle =>
			if(start_bit_flg = '1') then
				next_state <= receive_data;
			end if;
			
		when start_bit =>
			next_state <= receive_data;
			ptr <= X"00";
			
		when receive_data =>
			if(rx_state = 7) then
				next_state <= stop_bit;
			else
				next_state <= receive_data;
			end  if;
			
		when stop_bit =>
			if(rx = '1') then
				out_valid <= '1';
				i_data_out <= data_buffer;
				next_state <= idle;
				if(start_bit_flg = '1') then
					if(ptr = 255 or i_line_rcv = '1') then
						ptr <= X"00";
					else
						ptr <= ptr + '1';
					end if;
				end if;
			elsif(rx = '0' and next_state = idle) then
				if(start_bit_flg = '1') then
					next_state <= receive_data;
				else
					next_state <= idle;
				end if;
				out_valid <= '0';
			else
				out_valid <= '0';
				next_state <= reset_state;
			end if;
			

		when others =>
			out_valid <= '0';
			next_state <= reset_state;
	end case;
end process;

line_rcv <= i_line_rcv;
data_out <= i_data_out;

end architecture behavioural;
