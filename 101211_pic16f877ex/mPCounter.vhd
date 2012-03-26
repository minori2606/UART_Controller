library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mPCounter is

	port(
			reset	:in std_logic;
			clk	:in std_logic;
			Q		:in std_logic;
			wr_pc	:in std_logic; -- [writng flag of program counter]
			wr_dat	:in std_logic_vector(12 downto 0); -- [adress of program memory for writing program counter]
			cmd		:in std_logic_vector(13 downto 0); -- [instruction code]
			adr		:out std_logic_vector(12 downto 0) -- [adress of program memory to program memory module]
			);
end mPCounter;

architecture RTL of mPCounter is

	component mStack
	port(
			reset	:in std_logic;
			clk		:in std_logic;
			write0	:in std_logic; -- [writing signal at the "call"]
			read0	:in std_logic; -- [reading signal at the "return" and "retlw" and "retfie"]
			Q		:in std_logic;
			datin	:in std_logic_vector(12 downto 0); -- [adress of program memory to stack module]
			datout	:out std_logic_vector(12 downto 0) -- [adress of program memory to program memory module]
			); 
end component;

component mCmdDecode
    Port ( cmd : in  STD_LOGIC_VECTOR (13 downto 0);
           addwf : out  STD_LOGIC;
           andwf : out  STD_LOGIC;
           clrf : out  STD_LOGIC;
           clrw : out  STD_LOGIC;
           comf : out  STD_LOGIC;
           decf : out  STD_LOGIC;
           decfsz : out  STD_LOGIC;
           incf : out  STD_LOGIC;
           incfsz : out  STD_LOGIC;
           iorwf : out  STD_LOGIC;
           movf : out  STD_LOGIC;
           movwf : out  STD_LOGIC;
           rlf : out  STD_LOGIC;
           rrf : out  STD_LOGIC;
           subwf : out  STD_LOGIC;
           swapf : out  STD_LOGIC;
           xorwf : out  STD_LOGIC;
           bcf : out  STD_LOGIC;
           bsf : out  STD_LOGIC;
           btfsc : out  STD_LOGIC;
           btfss : out  STD_LOGIC;
			  addlw	: out STD_logic;
           andlw : out  STD_LOGIC;
           call : out  STD_LOGIC;
           goto : out  STD_LOGIC;
           iorlw : out  STD_LOGIC;
           movlw : out  STD_LOGIC;
			  retfie	: out STD_logic;
           retlw : out  STD_LOGIC;
			  return0: out STD_logic;
           xorlw : out  STD_LOGIC;
           sleep : out  STD_LOGIC;
           clrwdt : out  STD_LOGIC;
			  sublw	: out STD_logic;
           nop : out  STD_LOGIC);
end component;

	signal call0		:std_logic; -- [call flag for stack module]
	signal ret		:std_logic; -- [return flag for stack module]
	signal pc_reg	:std_logic_vector(12 downto 0); -- [same as "adr"]
	signal sdout	:std_logic_vector(12 downto 0); -- [adress of program memory from stack module]
	-- [each signal]
	signal CALL	:std_logic;
	signal GOTO	:std_logic;
	signal RETLW:std_logic;
	signal RETFIE:std_logic;
	signal RETURN0:std_logic;
	

begin

	process (CALL) begin
		if (CALL='1') then
			call0 <= '1';
		else 
			call0 <= '0';
		end if;
	end process;

	process (RETLW,RETURN0,RETFIE) begin
		if (RETLW='1' or RETURN0='1' or RETFIE='1') then
			ret <= '1';
		else
			ret <= '0';
		end if;
	end process;
	
	adr <= pc_reg;

	process (clk,reset) begin
		if (reset='1') then
			pc_reg <= "0000000000000";
		elsif (clk'event and clk='1') then	
				if (Q='1') then
					if (GOTO='1' or CALL='1') then -- [process when jump instruction]
						pc_reg <= "00" & cmd(10 downto 0);
					elsif (RETLW='1' or RETURN0='1' or RETFIE='1') then -- [process when return instruction]
						pc_reg <= sdout;
					elsif (wr_pc='1') then -- [process when writing program counter]
						pc_reg <= wr_dat;
					else -- [usual operation]
						pc_reg <= pc_reg + '1';
					end if;
				end if;
		end if;
	end process;
	
	stack	:mStack port map (
								reset	=> reset,
								clk		=> clk,
								write0	=> call0,
								read0	=> ret,
								Q		=> Q,
								datin	=> pc_reg,
								datout	=> sdout);

	cmddecode : mCmdDecode port map
			( cmd => cmd,
           addwf => open,
           andwf => open,
           clrf => open,
           clrw => open,
           comf => open,
           decf => open,
           decfsz => open,
           incf => open,
           incfsz => open,
           iorwf => open,
           movf => open,
           movwf => open,
           rlf => open,
           rrf => open,
           subwf => open,
           swapf => open,
           xorwf => open,
           bcf => open,
           bsf => open,
           btfsc => open,
           btfss => open,
           andlw => open,
           call => CALL,
           goto => GOTO,
           iorlw => open,
           movlw => open,
           retlw => RETLW,
           retfie => RETFIE,
           return0 => RETURN0,
			  sublw => open,
			  addlw => open,
           xorlw => open,
			  sleep => open,
           clrwdt => open,
           nop => open);
end RTL;
