----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:12:19 08/01/2009 
-- Design Name: 
-- Module Name:    mCmdDecode - Behavioral 
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

entity mCmdDecode is
    Port ( cmd : in  STD_LOGIC_VECTOR (13 downto 0); -- [instruction code]
				-- [each instruction signal]
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
end mCmdDecode;

architecture Behavioral of mCmdDecode is

begin

	process (cmd) begin
		if ( cmd(13 downto 8)="000111" ) then
			addwf <= '1';
		else
			addwf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="000101" ) then
			andwf <= '1';
		else
			andwf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 7)="0000011" ) then
			clrf <= '1';
		else
			clrf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 7)="0000010" ) then
			clrw <= '1';
		else
			clrw <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001001" ) then
			comf <= '1';
		else
			comf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="000011" ) then
			decf <= '1';
		else
			decf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001011" ) then
			decfsz <= '1';
		else
			decfsz <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001010" ) then
			incf <= '1';
		else
			incf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001111" ) then
			incfsz <= '1';
		else
			incfsz <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="000100" ) then
			iorwf <= '1';
		else
			iorwf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001000" ) then
			movf <= '1';
		else
			movf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 7)="0000001" ) then
			movwf <= '1';
		else
			movwf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001101" ) then
			rlf <= '1';
		else
			rlf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001100" ) then
			rrf <= '1';
		else
			rrf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="000010" ) then
			subwf <= '1';
		else
			subwf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="001110" ) then
			swapf <= '1';
		else
			swapf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="000110" ) then
			xorwf <= '1';
		else
			xorwf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 10)="0100" ) then
			bcf <= '1';
		else
			bcf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 10)="0101" ) then
			bsf <= '1';
		else
			bsf <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 10)="0110" ) then
			btfsc <= '1';
		else
			btfsc <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 10)="0111" ) then
			btfss <= '1';
		else
			btfss <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="111110" ) then
			addlw <= '1';
		else
			addlw <= '0';
		end if;
	end process;
		
	process (cmd) begin
		if ( cmd(13 downto 8)="111001" ) then
			andlw <= '1';
		else
			andlw <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 11)="100" ) then
			call <= '1';
		else
			call <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 11)="101" ) then
			goto <= '1';
		else
			goto <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="111000" ) then
			iorlw <= '1';
		else
			iorlw <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 10)="1100" ) then
			movlw <= '1';
		else
			movlw <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 10)="1101" ) then
			retlw <= '1';
		else
			retlw <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="111010" ) then
			xorlw <= '1';
		else
			xorlw <= '0';
		end if;
	end process;
		
	process (cmd) begin
		if ( cmd="00000001100100" ) then
			clrwdt <= '1';
		else
			clrwdt <= '0';
		end if;
	end process;

	process (cmd) begin
		if ( cmd="00000000001001" ) then
			retfie <= '1';
		else
			retfie <= '0';
		end if;
	end process;

	process (cmd) begin
		if ( cmd="00000000001000" ) then
			return0 <= '1';
		else
			return0 <= '0';
		end if;
	end process;

	process (cmd) begin
		if ( cmd="00000001100011" ) then
			sleep <= '1';
		else
			sleep <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd="00000000000000" ) then
			nop <= '1';
		else
			nop <= '0';
		end if;
	end process;
	
	process (cmd) begin
		if ( cmd(13 downto 8)="111100" ) then
			sublw <= '1';
		else
			sublw <= '0';
		end if;
	end process;
	
end Behavioral;

