library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mALU is

	port(
			cmd		:in std_logic_vector(13 downto 0); -- [instruction code]
			wreg	:in std_logic_vector(7 downto 0); -- [signal from working register module]
			datin	:in std_logic_vector(7 downto 0); -- [signal to ALU module]
			cin		:in std_logic; -- [carry flag from file register module(for shift instruction)]
			datout	:out std_logic_vector(7 downto 0);
			cout	:out std_logic; -- [carry to file register module]
			dc		:out std_logic; -- [digit carry to file register module]
			zf		:out std_logic; -- [zero flag to file register module]
			wr_f	:out std_logic; -- [writing file register flag to file register module]
			wr_w	:out std_logic; -- [writing working register flag to file register module]
			wr_c	:out std_logic; -- [writing carry flag to file register module]
			wr_dc	:out std_logic; -- [writing digit carry flag to file register module]
			wr_zf	:out std_logic; -- [writing zero flag to file register module]
			lite	:out std_logic_vector(7 downto 0); -- [literal signal]
			cmd_skip:out std_logic -- [flag that cleras instruction code]
			);

end mALU;

architecture RTL of mALU is

-- [8bits adding machine]
component madder8
	port(
			dat1	:in std_logic_vector(7 downto 0); -- [add data]
			dat2	:in std_logic_vector(7 downto 0); -- [be added data]
			cin	:in std_logic; -- [carry signal from ALU module]
			out0	:out std_logic_vector(7 downto 0); -- [data out]
			cout	:out std_logic; -- [carry signal to ALU module]
			dc		:out std_logic -- [digit carry signal to ALU module]
			);
end component;

-- [bitmask module]
component mBitMask
	port(
			bitin	:in std_logic_vector(2 downto 0);
			mask	:out std_logic_vector(7 downto 0)
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
--           option : out  STD_LOGIC;
           sleep : out  STD_LOGIC;
           clrwdt : out  STD_LOGIC;
			  sublw	: out STD_logic;
--           tris : out  STD_LOGIC;
           nop : out  STD_LOGIC);
end component;

	signal addout	:std_logic_vector(7 downto 0); -- [same as "datout"]
	signal w_wreg	:std_logic_vector(7 downto 0); -- [same as "wreg"]
	signal w_datin	:std_logic_vector(7 downto 0); -- [same as "datin"]
	signal w_datout:std_logic_vector(7 downto 0); -- [same as "datout"]
	signal bitmask	:std_logic_vector(7 downto 0); -- [signal from bitmask module]
	signal acin		:std_logic; -- [carry signal to adder8 module]
	signal acout	:std_logic; -- [carry signal from adder8 module]
	signal zf0		:std_logic; -- [same as zf]
	signal w_nwreg	:std_logic_vector(7 downto 0); -- [complement wreg]signal	addwf :STD_LOGIC;
	-- [each instruction signal]
	signal	addwf :STD_LOGIC;
	signal	andwf :STD_LOGIC;
	signal	clrf :STD_LOGIC;
	signal	clrw :STD_LOGIC;
	signal	comf :STD_LOGIC;
	signal	decf :STD_LOGIC;
	signal	decfsz :STD_LOGIC;
	signal	incf :STD_LOGIC;
	signal	incfsz :STD_LOGIC;
	signal	iorwf :STD_LOGIC;
	signal	movf :STD_LOGIC;
	signal	movwf :STD_LOGIC;
	signal	rlf :STD_LOGIC;
	signal	rrf :STD_LOGIC;
	signal	subwf :STD_LOGIC;
	signal	swapf :STD_LOGIC;
	signal	xorwf :STD_LOGIC;
	signal	bcf :STD_LOGIC;
	signal	bsf :STD_LOGIC;
	signal	btfsc :STD_LOGIC;
	signal	btfss :STD_LOGIC;
	signal	andlw :STD_LOGIC;
	signal	call :STD_LOGIC;
	signal	goto :STD_LOGIC;
	signal	iorlw :STD_LOGIC;
	signal	movlw :STD_LOGIC;
	signal	retlw :STD_LOGIC;
	signal	xorlw :STD_LOGIC;
	signal	clrwdt :STD_LOGIC;
	signal	nop :STD_LOGIC;	
	signal	addlw :STD_LOGIC;
	signal	sublw :STD_LOGIC;
	signal	retfie :STD_LOGIC;
	signal	return0 :STD_LOGIC;
	signal	sleep :STD_LOGIC;
	signal	wr_f0	:std_logic; -- [same as wr_f]
	signal	wr_w0	:std_logic;	-- [same as wr_w]
	
begin

	w_nwreg <= not wreg;

-- [process when subtract]
	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,cmd) begin
		if (subwf='1' or sublw='1') then
			acin <= '1';
		else
			acin <= '0';
		end if;
	end process;

-- [wreg process]
	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,bitmask,wreg,cmd,w_nwreg) begin
		if (subwf='1' or sublw='1') then
			w_wreg <= w_nwreg;-- [process when compolement]
		elsif (incf='1' or incfsz='1') then
			w_wreg <= "00000001";-- [process when increment]
		elsif (decf='1' or decfsz='1') then
			w_wreg <= "11111111";-- [process when decrement]
		elsif (bsf='1' or btfsc='1' or btfss='1') then
			w_wreg <= bitmask;-- [process when bit operation (set)]
		elsif (bcf='1') then
			w_wreg <= not bitmask;-- [process when bit operation (clear)]
		else -- [usual operation]
			w_wreg <= wreg;
		end if;
	end process;

-- [datin and lite process]
	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,datin,cmd) begin
		if (andlw='1' or iorlw='1' or movlw='1' or retlw='1' or xorlw='1' or sublw='1' or addlw='1') then-- [process when literal instraction]
			w_datin <= cmd(7 downto 0);
			lite		<= cmd(7 downto 0);
		else
			w_datin <= datin;
			lite		<= "00000000";
		end if;
	end process;

	adder:mAdder8 port map(
								dat1	=> w_wreg,
								dat2	=> w_datin,
								cin	=> acin,
								out0	=> addout,
								cout	=> acout,
								dc		=> dc);

	bmask:mBitMask port map(
								bitin	=> cmd(9 downto 7),
								mask	=> bitmask);

-- [shift process]
	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,cmd,datin,acout) begin
		if (rlf='1') then
			cout <= datin(7);-- [process when leftshift]
		elsif (rrf='1') then
			cout <= datin(0);-- [process when rightshift]
		else
			cout <= acout; -- [usual process (acount is from adding machine)]
		end if;
	end process;

	datout <= w_datout;

	zf <= zf0;

	process (w_datout) begin
		if (w_datout="00000000") then -- [process when zero]
			zf0 <= '1';
		else
			zf0 <= '0';
		end if;
	end process;

	wr_f <= wr_f0;
	wr_w <= wr_w0;

-- [datout process]
	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,w_datin,wr_f0,wr_w0,cmd,addout,w_wreg,cin) begin
		if (addwf='1' or addlw='1' or sublw='1' or subwf='1' or incf='1' or incfsz='1' or decf='1' or decfsz='1') then
			w_datout <= addout;-- [process when use adding machine]
		elsif (andwf='1' or andlw='1' or bcf='1' or btfsc='1' or btfss='1') then
			w_datout <= w_wreg and w_datin;-- [process when "and" operating]
		elsif (clrf='1' or clrw='1') then
			w_datout <= "00000000";-- [process when "clear" operating]
		elsif (iorwf='1' or bsf='1' or iorlw='1') then
			w_datout <= w_datin or w_wreg;-- [process when "or" operating]
		elsif (rlf='1') then
			w_datout <= w_datin(6 downto 0) & cin;-- [process when "leftshift" operating]
		elsif (rrf='1') then
			w_datout <= cin & w_datin(7 downto 1);-- [process when "rightshift" operating]
		elsif (xorwf='1' or xorlw='1') then
			w_datout <= w_wreg xor w_datin;-- [process when "xor" operating]
		elsif (swapf='1') then
			w_datout <= w_datin(3 downto 0) & w_datin(7 downto 4);-- [process when "swap" operating]
		elsif (comf='1') then
			w_datout <= not w_datin;-- [process when "compelement" operating]
		elsif (movf='1' or movlw='1' or retlw='1') then
			w_datout <= w_datin;-- [process when out signal that from file register]
		else
			w_datout <= w_wreg;-- [process when out signal that from working register]
		end if;
	end process;


	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,sublw,addlw,retfie,return0,sleep,nop,cmd) begin
		if (((addwf='1' or andwf='1' or clrf='1' or comf='1' or decf='1' or decfsz='1'
			or incf='1' or incfsz='1' or iorwf='1' or movf='1' or rlf='1' or rrf='1' 
			or subwf='1' or swapf='1' or xorwf='1') and cmd(7)='1') or (movwf='1' or bcf='1' or bsf='1')) then
			wr_f0 <= '1'; -- [process when d bit is '1']
		else
			wr_f0 <= '0';
		end if;
	end process;


	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,cmd) begin
		if (((addwf='1' or andwf='1' or clrw='1' or comf='1' or decf='1' or decfsz='1'
			or incf='1' or incfsz='1' or iorwf='1' or movf='1' or rlf='1' or rrf='1'
			or subwf='1' or swapf='1' or xorwf='1') and cmd(7)='0') or (andlw='1' or iorlw='1'
			or movlw='1' or retlw='1' or xorlw='1' or addlw='1' or sublw='1')) then
			wr_w0 <= '1'; -- [process when d bit is '0']
		else
			wr_w0 <= '0';
		end if;
	end process;


	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,cmd) begin
		if (addwf='1' or rlf='1' or rrf='1' or subwf='1' or addlw='1' or sublw='1') then
			wr_c <= '1';-- [process when writing carry]
		else
			wr_c <= '0';
		end if;
	end process;


	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,cmd) begin
		if (addwf='1' or subwf='1' or addlw='1' or sublw='1') then
			wr_dc <= '1';-- [process when writing digit carry]
		else
			wr_dc <= '0';
		end if;
	end process;


	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,cmd) begin
		if (addwf='1' or andwf='1' or clrf='1' or clrw='1' or comf='1' or decf='1'
			or incf='1' or iorwf='1' or movf='1' or subwf='1' or xorwf='1' OR andlw='1'
			or iorlw='1' or xorlw='1' or addlw='1' or sublw='1') then
			wr_zf <= '1';-- [process when writing zero flag]
		else
			wr_zf <= '0';
		end if;
	end process;



	process (addwf,andwf,clrf,clrw,comf,decf,decfsz,incf,incfsz,iorwf,movf,movwf,rlf,rrf,subwf,swapf,xorwf,bcf,bsf,btfsc,btfss,
		andlw,call,goto,iorlw,movlw,retlw,xorlw,clrwdt,nop,sublw,addlw,retfie,return0,sleep,zf0,cmd) begin
		if (((decfsz='1' or incfsz='1' or btfsc='1') and zf0='1')or (btfss='1' and zf0='0')) then
			cmd_skip <= '1';-- [process when command skip]
		else
			cmd_skip <= '0';
		end if;
	end process;

	cmddeco:mCmdDecode port map(
			cmd => cmd,
			addwf => addwf,
			andwf => andwf,
			clrf => clrf,
			clrw => clrw,
			comf => comf,
			decf => decf,
			decfsz => decfsz,
			incf => incf,
			incfsz => incfsz,
			iorwf => iorwf,
			movf => movf,
			movwf => movwf,
			rlf => rlf,
			rrf => rrf,
			subwf => subwf,
			swapf => swapf,
			xorwf => xorwf,
			bcf => bcf,
			bsf => bsf,
			btfsc => btfsc,
			btfss => btfss,
			andlw => andlw,
			call => call,
			goto => goto,
			iorlw => iorlw,
			movlw => movlw,
			retlw => retlw,
			xorlw => xorlw,
			clrwdt => clrwdt,
			addlw => addlw,
			sublw => sublw,
			sleep => sleep,
			retfie => retfie,
			return0 => return0,
			nop => nop);
	

           
end RTL;