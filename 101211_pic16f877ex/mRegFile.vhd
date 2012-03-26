library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mRegFile is

	port(
			reset	:in std_logic;
			clk	:in std_logic;
			Q		:in std_logic;
			fadr	:in std_logic_vector(6 downto 0);-- [adress of file register]
			datin	:in std_logic_vector(7 downto 0);-- [signal from ALU module]
			datout:out std_logic_vector(7 downto 0);--[signal to ALU module]
			cin	:in std_logic; -- [carry from ALU module]
			cout	:out std_logic; -- [carry to ALU module]
			dc		:in std_logic; -- [digit carry from ALU module]
			zf		:in std_logic; -- [zero flag from ALU module]
			wr_cf	:in std_logic; -- [writing carry flag from ALU module]
			wr_dc	:in std_logic; -- [writing digit carry flag from ALU module]
			wr_zf	:in std_logic; -- [writing zero flag from ALU module]
			wr_fr	:in std_logic; -- [writing file register flag from ALU module]
			porta_in	:in std_logic_vector(7 downto 0); -- [signal from porta]
			portb_in	:in std_logic_vector(7 downto 0); -- [signal from portb]
			portc_in	:in std_logic_vector(7 downto 0); -- [signal from portc]
			portd_in	:in std_logic_vector(7 downto 0); -- [signal from portd]
			porte_in	:in std_logic_vector(7 downto 0); -- [signal from porte]
			porta_out:out std_logic_vector(7 downto 0); -- [signal to porta]
			portb_out:out std_logic_vector(7 downto 0); -- [signal to portb]
			portc_out:out std_logic_vector(7 downto 0); -- [signal to portc]
			portd_out:out std_logic_vector(7 downto 0); -- [signal to portd]
			porte_out:out std_logic_vector(7 downto 0); -- [signal to porte]
			pc_in	:in std_logic_vector(12 downto 0); -- [adress of program memory from program counter module]
			pc_out:out std_logic_vector(12 downto 0); -- [adress of program memory to program counter module]
			wr_pc	:out std_logic; -- [writing flag of program coumter]
			timer_in:in std_logic_vector(7 downto 0); -- [signal from timer0]
			wr_tmr	:out std_logic; -- [writing flag of timer0]
			opt_out	:out std_logic_vector(7 downto 0); -- [signal from option reg]
			cmd		:in std_logic_vector(13 downto 0); -- [instruction code]
			
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
			
			debug_ram_out : out std_logic_vector(31 downto 0)


			);
	
end mRegFile;

architecture RTL of mRegFile is

-- [status register]
component mStatus

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_zf	:in std_logic;
			wr_dc	:in std_logic;
			wr_cf	:in std_logic;
			wr_fr	:in std_logic;
			wr_rps	:in std_logic; -- [flag when rp set]
			wr_rpc	:in std_logic; -- [flag when rp clear]
			rp0	:in std_logic; -- [bit mask]
			rp1	:in std_logic; -- [bit mask]
			zf		:in std_logic;
			dc		:in std_logic;
			cf		:in std_logic;
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0)
			);
end component;

-- [option register]
component mOption

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_opt	:in std_logic;
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0)
			);
end component;

---- [each tris register]
--component mTris
--
--	port(
--			reset	:in std_logic;
--			clk		:in std_logic;
--			Q		:in std_logic;
--			wr_tris	:in std_logic;
--			datin	:in std_logic_vector(7 downto 0);
--			datout	:out std_logic_vector(7 downto 0)
--			);
--end component;

-- [fsr register]
component mFsr

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_fsr	:in std_logic;
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0)
			);
end component;

-- [each port register]
component mGpio

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_gpio	:in std_logic;
			datin	:in std_logic_vector(7 downto 0);
			datout	:out std_logic_vector(7 downto 0)
			);
end component;

-- [pclatch]
component mpclath

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			Q		:in std_logic;
			wr_pclath	:in std_logic;
			datin	:in std_logic_vector(4 downto 0);
			datout	:out std_logic_vector(4 downto 0));
end component;

	signal iadr		:std_logic_vector(6 downto 0);-- [inner flag]
	signal fsr_out	:std_logic_vector(7 downto 0);-- [signal from fsr register]
	signal st_out	:std_logic_vector(7 downto 0);-- [signal from status register]
	-- [general purpose register]
	type ramtype0 is array (0 to 127) of std_logic_vector(7 downto 0);
	signal ram0	:ramtype0;
	signal ram1	:ramtype0;
	signal ram2	:ramtype0;
	signal ram3	:ramtype0;
	--[each writing flag]
	signal wr_st	:std_logic;
	signal wr_fsr	:std_logic;
	signal wr_opt	: std_logic;
	signal wr_pclath	: std_logic;
	signal wr_rps	:std_logic;
	signal wr_rpc	:std_logic;
	signal wr_porta	:std_logic:='0';
	signal wr_portb	:std_logic:='0';
	signal wr_portc	:std_logic:='0';
	signal wr_portd	:std_logic:='0';
	signal wr_porte	:std_logic:='0';
	signal wr_ram0	:std_logic;
	signal wr_ram1	:std_logic;
	signal wr_ram2	:std_logic;
	signal wr_ram3	:std_logic;
	
	signal rp0	:std_logic; -- [same as cmd(7)]
	signal rp1	:std_logic; -- [same as cmd(8)]
	signal f_eva	:std_logic;-- [for mis-operation evasion]
	signal pclath_out0:std_logic_vector(4 downto 0); -- [signal from pclatch(high bits)]
	signal pclath_out	:std_logic_vector(7 downto 0); -- [signal from pclatch]
	-- [each bank signal]
	signal fbank0		:std_logic:='0';
	signal fbank1		:std_logic:='0';
	signal fbank2		:std_logic:='0';
	signal fbank3		:std_logic:='0';
	-- [each port signal]
	signal porta_out0	:std_logic_vector(7 downto 0);
	signal portb_out0	:std_logic_vector(7 downto 0);
	signal portc_out0	:std_logic_vector(7 downto 0);
	signal portd_out0	:std_logic_vector(7 downto 0);
	signal porte_out0	:std_logic_vector(7 downto 0);
	
	signal iadr10	:integer range 0 to 127; -- [for affixing character]

begin

	porta_out <= porta_out0;
	portb_out <= portb_out0;
	portc_out <= portc_out0;
	portd_out <= portd_out0;
	porte_out <= porte_out0;

	iadr10 <= conv_integer(iadr(6 downto 0));

	cout <= st_out(0);-- [0 bit of status register is carry]

	pc_out <= pclath_out(4 downto 0) & datin;-- [signal to program counter module]

-- [process fsr register]
	process (fadr,clk,fsr_out) begin
		if (fadr(6 downto 0)="0000000") then
			iadr <= fsr_out(6 downto 0);
		else
			iadr <= fadr;
		end if;
	end process;

-- [process datout]
	process (iadr,timer_in,pc_in,st_out,fsr_out,clk,fbank0,fbank2,pclath_out,fbank1,fbank3,ram0,ram1,ram2,ram3,fadr,cmd,iadr10) begin
		if (iadr="0000001" and (fbank0='1' or fbank2='1')) then
			datout <= timer_in; -- [timer0 process]
		elsif (iadr="0000010") then
			datout <= pc_in(7 downto 0); -- [program counter process]
		elsif (iadr="0000011") then
			datout <= st_out; -- [status register process]
		elsif (iadr="0000100") then
			datout <= fsr_out; -- [fsr register process]
		-- [for Value immediately data instruction]
		elsif ((cmd(13 downto 7)="0000000" and cmd(4 downto 0)="00000") or cmd(13 downto 10)="1100"
				or cmd(13 downto 7)="0000001" or cmd(13 downto 8)="111001" or cmd(13 downto 11)="101"
				or cmd(13 downto 7)="0000011" or cmd(13 downto 7)="0000010" or cmd(13 downto 8)="111110"
				or cmd(13 downto 11)="100" or cmd(13 downto 8)="111000" or cmd(13 downto 10)="1101"
				or cmd(13 downto 8)="111010" or cmd="00000001100100" or cmd="00000000001000" or cmd(13 downto 8)="111100"
				) then
			datout <= "00000000";
			
		elsif (iadr="0000101" and fbank0='1') then -- [porta process]
			datout <= porta_in;
		elsif (iadr="0000110" and (fbank0='1' or fbank2='1')) then-- [portb process]
			datout <= portb_in;
		elsif (iadr="0000111" and fbank0='1') then-- [portc process]
			datout <= portc_in;
		elsif (iadr="0001000" and fbank0='1') then-- [portd process]
			datout <= portd_in;
		elsif (iadr="0001001" and fbank0='1') then-- [porte process]
			datout <= porte_in;
		elsif (iadr="0001010") then -- [pclatch process]
			datout <= pclath_out;
			
		-- [process that select bank of general purpose register]
		elsif (((iadr(5)='1' or iadr(6)='1') and fbank0='1') or
			(iadr(6 downto 4)="111" and (fbank1='1' or fbank2='1' or fbank3='1'))) then
			datout <= ram0(iadr10);
		elsif ((iadr(5)='1' or iadr(6)='1') and fbank1='1') then
			datout <= ram1(iadr10);
		elsif ((iadr(4)='1' or iadr(5)='1' or iadr(6)='1') and fbank2='1') then
			datout <= ram2(iadr10);
		elsif ((iadr(5)='1' or iadr(6)='1') and fbank0='1') then
			datout <= ram3(iadr10);
		end if;
	end process;

-- [each bank flag]
	process (st_out,clk) begin
		if (st_out(6 downto 5)="00") then
			fbank0 <= '1'; 
		else
			fbank0 <= '0';
		end if;
	end process;

	process (st_out,clk) begin
		if (st_out(6 downto 5)="01") then
			fbank1 <= '1'; 
		else
			fbank1 <= '0';
		end if;
	end process;

	process (st_out,clk) begin
		if (st_out(6 downto 5)="10") then
			fbank2 <= '1'; 
		else
			fbank2 <= '0';
		end if;
	end process;
	
	process (st_out,clk) begin
		if (st_out(6 downto 5)="11") then
			fbank3 <= '1'; 
		else
			fbank3 <= '0';
		end if;
	end process;
-- [process for write to ram]
	process (clk) begin
		if (clk'event and clk='1') then
			ram0(40) <= in_distance_0;
			ram0(41) <= in_distance_1;
			ram0(42) <= in_distance_2;
			ram0(43) <= in_distance_3;
			ram0(44) <= in_distance_4;
			ram0(45) <= in_distance_5;
			ram0(46) <= in_distance_6;
			ram0(47) <= in_distance_7;
			ram0(48) <= in_angle_0;
			ram0(49) <= in_angle_1;
			ram0(50) <= in_angle_2;
			ram0(51) <= in_angle_3;
			ram0(52) <= in_angle_4;
			ram0(53) <= in_angle_5;
			ram0(54) <= in_angle_6;
			ram0(55) <= in_angle_7;
			
			txdata <= ram0(56);
			
			ram0(35) <= statusin;
			statusout <= ram0(36);
			
			ram0(37) <= rxdata;
			line_ptr <= ram0(38);

			
			debug_ram_out <= ram0(39) & ram0(38) & ram0(37) & ram0(36);
		
			-- [usual operation]
			if (Q='1') then
				if (wr_ram0='1') then
					ram0(iadr10) <= datin;
				elsif	 (wr_ram1='1') then
					ram1(iadr10) <= datin;
				elsif	 (wr_ram2='1') then
					ram2(iadr10) <= datin;
				elsif	 (wr_ram3='1') then
					ram3(iadr10) <= datin;
				end if;
			end if;
		end if;
	end process;
	

-- [each writing flag process]
	process (iadr,wr_fr,clk,fbank0,fbank2) begin
		if (iadr="0000001" and (fbank0='1' or fbank2='1')) then
			wr_tmr <= wr_fr;
		else
			wr_tmr <= '0';
		end if;
	end process;
	
	process (iadr,wr_fr,clk,fbank1,fbank3) begin
		if (iadr="0000001" and (fbank1='1' or fbank3='1')) then
			wr_opt <= wr_fr;
		else
			wr_opt <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk) begin
		if (iadr="0000010") then
			wr_pc <= wr_fr;
		else
			wr_pc <= '0';
		end if;
	end process;

	process (iadr,wr_pclath,clk) begin
		if (iadr="0001010") then
			wr_pclath <= wr_fr;
		else
			wr_pclath <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk) begin
		if (iadr="0000011") then
			wr_st <= wr_fr;
		else
			wr_st <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk) begin
		if (iadr="0000100") then
			wr_fsr <= wr_fr;
		else
			wr_fsr <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank0,f_eva) begin
		if (iadr="0000101" and fbank0='1' and f_eva='0') then
			wr_porta <= wr_fr;
		else
			wr_porta <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank0,fbank2,f_eva) begin
		if (iadr="0000110" and (fbank0='1' or fbank2='1') and f_eva='0') then
			wr_portb <= wr_fr;
		else
			wr_portb <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank0,f_eva) begin
		if (iadr="0000111" and fbank0='1' and f_eva='0') then
			wr_portc <= wr_fr;
		else
			wr_portc <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank0,f_eva) begin
		if (iadr="0001000" and fbank0='1' and f_eva='0') then
			wr_portd <= wr_fr;
		else
			wr_portd <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank0,f_eva) begin
		if (iadr="0001001" and fbank0='1' and f_eva='0') then
			wr_porte <= wr_fr;
		else
			wr_porte <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank0,fbank1,fbank2,fbank3) begin
		if (((iadr(5)='1' or iadr(6)='1') and fbank0='1') or
			(iadr(6 downto 4)="111" and (fbank1='1' or fbank2='1' or fbank3='1'))) then
			wr_ram0 <= wr_fr;
		else
			wr_ram0 <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank1) begin
		if ((iadr(5)='1' or iadr(6)='1') and fbank1='1') then
			wr_ram1 <= wr_fr;
		else
			wr_ram1 <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank2) begin
		if ((iadr(4)='1' or iadr(5)='1' or iadr(6)='1') and fbank2='1') then
			wr_ram2 <= wr_fr;
		else
			wr_ram2 <= '0';
		end if;
	end process;

	process (iadr,wr_fr,clk,fbank3) begin
		if ((iadr(4)='1' or iadr(5)='1' or iadr(6)='1') and fbank3='1') then
			wr_ram3 <= wr_fr;
		else
			wr_ram3 <= '0';
		end if;
	end process;

	process (cmd,clk,iadr) begin
		if (iadr="0000011" and cmd(13 downto 10)="0101" and (cmd(9 downto 7)="101" or cmd(9 downto 7)="110")) then
			wr_rps <= '1';
		else
			wr_rps <= '0';
		end if;
	end process;
	
	process (cmd,clk,iadr) begin
		if (iadr="0000011" and cmd(13 downto 10)="0100" and (cmd(9 downto 7)="101" or cmd(9 downto 7)="110")) then
			wr_rpc <= '1';
		else
			wr_rpc <= '0';
		end if;
	end process;	

-- [for mis-operation evasion]
	process (cmd,clk) begin
		if (cmd(13 downto 12)="11" or cmd(13 downto 12)="10") then
			f_eva <= '1';
		else
			f_eva <= '0';
		end if;
	end process;

	rp0 <= cmd(7);
	rp1 <= cmd(8);
	
	streg:mStatus port map(
							reset	=> reset,
							clk		=> clk,
							Q		=> Q,
							wr_zf	=> wr_zf,
							wr_dc	=> wr_dc,
							wr_cf	=> wr_cf,
							wr_fr	=> wr_st,
							wr_rps => wr_rps,
							wr_rpc => wr_rpc,
							rp0	=> rp0,
							rp1	=> rp1,
							zf		=> zf,
							dc		=> dc,
							cf		=> cin,
							datin	=> datin,
							datout	=> st_out);

	optreg:mOption port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_opt	=> wr_opt,
			datin	=> datin,
			datout	=> opt_out);

	fsrreg:mFsr port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_fsr	=> wr_fsr,
			datin	=> datin,
			datout	=> fsr_out);


	portareg:mGpio port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_gpio	=> wr_porta,
			datin	=> datin,
			datout	=> porta_out0);


	portbreg:mGpio port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_gpio	=> wr_portb,
			datin	=> datin,
			datout	=> portb_out0);


	portcreg:mGpio port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_gpio	=> wr_portc,
			datin	=> datin,
			datout	=> portc_out0);


	portdreg:mGpio port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_gpio	=> wr_portd,
			datin	=> datin,
			datout	=> portd_out0);


	portereg:mGpio port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_gpio	=> wr_porte,
			datin	=> datin,
			datout	=> porte_out0);
			
	pclathreg:mpclath port map(
			reset	=> reset,
			clk		=> clk,
			Q		=> Q,
			wr_pclath	=> wr_pclath,
			datin	=> pc_in(12 downto 8),
			datout	=>pclath_out0);			
			
			pclath_out <= "000" & pclath_out0;

end RTL;

