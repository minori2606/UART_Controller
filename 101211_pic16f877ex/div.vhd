-- Title    : Divider
-- Designer : Kosei Shimoo
-- Date     : 2004.09.09
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity div is
	generic(
		W : integer);
	port(
		X :in std_logic_vector(W-1 downto 0);
		Y: in std_logic_vector(W-1 downto 0);
		Q: out std_logic_vector(W-1 downto 0);
		R: out std_logic_vector(W-1 downto 0);
		CLK: in std_logic;
		START: in std_logic;
		OPEND: out std_logic);
end div;

architecture div_arch of div is
-- signal declaration --
signal YY: std_logic_vector(W-1 downto 0);
signal X_MSB: std_logic;
signal ASS: std_logic; -- Adder/Subtractor Select
signal AS: std_logic_vector(W-1 downto 0);
signal AS2: std_logic_vector(W-1 downto 0);
signal MA: std_logic_vector(W downto 0);
signal MB: std_logic_vector(W-1 downto 0);
signal RR: std_logic_vector(W downto 0);
signal QQ: std_logic_vector(W-1 downto 0);
signal CNTOUT: integer range 0 to W;
signal C_St: std_logic;
signal tmpQ: std_logic;

begin
	U0: process(CLK) begin
		if(CLK'event and CLK='1') then
			if(START='1') then
				YY <= Y;
			end if;
		end if;
	end process;

	U02: process(CLK) begin
		if(CLK'event and CLK='1') then
			if(START='1') then
				X_MSB <= X(W-1);
			else
				X_MSB <= X_MSB;
			end if;
		end if;
	end process;

	U1: process(YY, RR, X_MSB) begin
		if(X_MSB='1' and RR=CONV_std_logic_vector(0,W)) then
			if(YY(W-1)='0') then
				AS <= RR(W-1 downto 0) + YY;
			else
				AS <= RR(W-1 downto 0) - YY;
			end if;
		elsif((YY(W-1) xor RR(W))='1') then
			AS <= RR(W-1 downto 0) + YY;
		else
			AS <= RR(W-1 downto 0) - YY;
		end if;
	end process;

	U2: process(START, X, AS, QQ) begin
		if(START='1') then
			MA <= (others => X(W-1));
		else
			MA <= AS & QQ(W-1);
		end if;
	end process;

	U4: process(CLK) begin
		if(CLK'event and CLK='1') then
			if(START='1' or (C_St='1' and CNTOUT/=W-1)) then
				RR <= MA;
			end if;
		end if;
	end process;

	U3: process(START, X, QQ, tmpQ) begin
		if(START='1') then
			MB <= X(W-2 downto 0) & '0';
		else
			MB <= QQ(W-2 downto 0) & tmpQ;
		end if;
	end process;

	U5: process(CLK) begin
		if(CLK'event and CLK='1') then
			if(START='1' or C_St='1') then
				QQ <= MB;
			end if;
		end if;
	end process;

	U6: process(X_MSB, AS) begin
		if(X_MSB='1' and AS=CONV_std_logic_vector(0,W)) then
			tmpQ <= '1';
		else
			tmpQ <= X_MSB xnor AS(W-1);
		end if;
	end process;

	UCNT: process(CLK) begin
		if(CLK'event and CLK='1') then
			if(START='1') then
				CNTOUT <= 0;
			elsif(C_St='1') then
				CNTOUT <= CNTOUT + 1;
			end if;
		end if;
	end process;

	U7: process(X_MSB, YY, QQ) begin
		if((X_MSB xor YY(W-1))='0') then
			Q <= QQ;
		else
			Q <= (not QQ) + CONV_std_logic_vector(1,W);
		end if;
	end process;

	U8: process(X_MSB, AS, AS2) begin
		if((X_MSB xor AS(W-1))='0') then
			R <= AS;
		else
			R <= AS2;
		end if;
	end process;

	U9: process(AS, X_MSB, YY) begin
		if((X_MSB xor YY(W-1))='1') then
			AS2 <= AS - YY;
		else
			AS2 <= AS + YY;
		end if;
	end process;

	process(CLK) begin
		if(CLK'event and CLK='1') then
			if((C_St='0' and START='1') or (C_St='1' and CNTOUT/=W-1)) then
				C_St <= '1';
			else
				C_St <= '0';
			end if;
		end if;
	end process;

	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(C_St='1' and CNTOUT=W-1) then
				OPEND <= '1';
			else
				OPEND <= '0';
			end if;
		end if;
	end process;

end div_arch;
