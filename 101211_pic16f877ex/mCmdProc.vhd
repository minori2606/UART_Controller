library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mCmdProc is

	port(
			cmd			:in std_logic_vector(13 downto 0); -- [instruction code]
			cmd_flash	:out std_logic); -- [signal that clears command]
end mCmdProc;

architecture RTL of mCmdProc is

	signal GOTO0	:std_logic;
	signal CALL0	:std_logic;
	signal RETLW0:std_logic;
	signal RETURN0:std_logic;
	signal RETFIE	:std_logic;
	
-- [command decoder]
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
           andlw : out  STD_LOGIC;
           call : out  STD_LOGIC;
           goto : out  STD_LOGIC;
           iorlw : out  STD_LOGIC;
           movlw : out  STD_LOGIC;
           retlw : out  STD_LOGIC;
           xorlw : out  STD_LOGIC;
           clrwdt : out  STD_LOGIC;
           return0 : out  STD_LOGIC;
           addlw : out  STD_LOGIC;
           sublw : out  STD_LOGIC;
           retfie : out  STD_LOGIC;
           sleep : out  STD_LOGIC;
           nop : out  STD_LOGIC);
end component;

begin

	process (GOTO0,CALL0,RETLW0,RETURN0,RETFIE) begin
		if (GOTO0='1' or CALL0='1' or RETLW0='1' or RETURN0='1' or RETFIE='1') then
			cmd_flash <= '1';
		else
			cmd_flash <= '0';
		end if;
	end process;

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
           call => CALL0,
           goto => GOTO0,
           iorlw => open,
           movlw => open,
           retlw => RETLW0,
           xorlw => open,
           clrwdt => open,
           nop => open,
			  return0 => RETURN0,
			  retfie => RETFIE,
			  addlw => open,
			  sublw => open,
			  sleep => open
			  );	

end RTL;
