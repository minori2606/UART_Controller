library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity TxD_driver is
	port(
		OSC	: in std_logic;	-- sample 50MHz
		TxD	: out std_logic;
		ASCII_IN	: in std_logic_vector(7 downto 0);
		READY	: out std_logic -- next ascii-code ready (pulse)
	);
end TxD_driver;

architecture behavioral of TxD_driver is

component CLK_divide
	generic(
		cvalue	: std_logic_vector(31 downto 0)
	);
	port(
		CLK		: in std_logic;
		RST		: in std_logic;
		DIVCLK	: out std_logic
		);
end component;

--when 50MHz => 9600bps : 50,000,000 /2 /9600 = X"A2C";
constant DIV_VAL	: std_logic_vector(31 downto 0):=X"00000A2C";

signal CLK : std_logic;
signal cnt : std_logic_vector(3 downto 0):=X"0";
signal tdata : std_logic_vector(7 downto 0) := X"00";
signal i_TxD : std_logic;
--constant tdata : std_logic_vector(7 downto 0) := X"58";
--constant asc_CR : std_logic_vector(7 downto 0) := X"0D";
--constant asc_LF : std_logic_vector(7 downto 0) := X"0A";
constant i_RST : std_logic := '0';

begin	
	-- boud rate generator
	CDIV0: CLK_divide generic map(DIV_VAL) port map(OSC, i_RST, CLK);
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(cnt="1001") then
				cnt <= (others => '0');
				READY <= '1';
			else
				cnt <= cnt + '1';
				READY <= '0';
			end if;
		end if;
	end process;

	-- TxD generator (data-8bit non-parity stopbit-1 non-flow)
	TxD <= i_TxD;
	process(cnt, tdata) begin
		case cnt is 
			when "0000" =>		--start bit
				i_TxD <= '0';
			when "0001" =>
				i_TxD <= tdata(0);
			when "0010" =>
				i_TxD <= tdata(1);
			when "0011" =>
				i_TxD <= tdata(2);
			when "0100" =>
				i_TxD <= tdata(3);
			when "0101" =>
				i_TxD <= tdata(4);
			when "0110" =>
				i_TxD <= tdata(5);
			when "0111" =>
				i_TxD <= tdata(6);
			when "1000" =>
				i_TxD <= tdata(7);
			when "1001" =>		--stopbit
				i_TxD <= '1';
			when others =>
				i_TxD <= '1';
		end case;
	end process;

	tdata <= ascii_IN;

--	-- display test
--	process(CLK, RST) begin
--		if(i_RST='1') then
--			tdata <= X"21";
--		elsif(CLK'event and CLK='1') then
--			if(cnt=X"0") then
--				if(tdata>=X"7E") then
--					tdata <= asc_CR;
--				elsif(tdata=asc_CR) then
--					tdata <= asc_LF;
--				elsif(tdata=asc_LF) then
--					tdata <= X"21";
--				else
--					tdata <= tdata + '1';
--				end if;
--			end if;
--		end if;
--	end process;
--
end behavioral;