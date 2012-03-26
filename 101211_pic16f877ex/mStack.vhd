library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mStack is

	port(
			reset	:in std_logic;
			clk		:in std_logic;
			write0	:in std_logic; -- [writing signal at the "call"]
			read0	:in std_logic; -- [reading signal at the "return" and "retlw" and "retfie"]
			Q		:in std_logic;
			datin	:in std_logic_vector(12 downto 0); -- [adress of program memory to stack module]
			datout	:out std_logic_vector(12 downto 0) -- [adress of program memory to program memory module]
			); 
end mStack;

architecture RTL of mStack is

	-- [stack of 8 layers]
	signal stack1	:std_logic_vector(12 downto 0);
	signal stack2	:std_logic_vector(12 downto 0);
	signal stack3	:std_logic_vector(12 downto 0);
	signal stack4	:std_logic_vector(12 downto 0);
	signal stack5	:std_logic_vector(12 downto 0);
	signal stack6	:std_logic_vector(12 downto 0);
	signal stack7	:std_logic_vector(12 downto 0);
	signal stack8	:std_logic_vector(12 downto 0);
	
begin

	datout <= stack1;

-- [first stack]
	process (clk,reset) begin
		if (reset='1') then
			stack1 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack1 <= datin;
			elsif (Q='1' and read0='1') then
				stack1 <= stack2;
			end if;
		end if;
	end process;

-- [second stack]
	process (clk,reset) begin
		if (reset='1') then
			stack2 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack2 <= stack1;
			elsif (Q='1' and read0='1') then
				stack2 <= stack3;
			end if;
		end if;
	end process;

-- [third stack]
	process (clk,reset) begin
		if (reset='1') then
			stack3 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack3 <= stack2;
			elsif (Q='1' and read0='1') then
				stack3 <= stack4;
			end if;
		end if;
	end process;

-- [forth stack]
	process (clk,reset) begin
		if (reset='1') then
			stack4 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack4 <= stack3;
			elsif (Q='1' and read0='1') then
				stack4 <= stack5;
			end if;
		end if;
	end process;

-- [fifth stack]
	process (clk,reset) begin
		if (reset='1') then
			stack5 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack5 <= stack4;
			elsif (Q='1' and read0='1') then
				stack5 <= stack6;
			end if;
		end if;
	end process;

-- [sixth stack]
	process (clk,reset) begin
		if (reset='1') then
			stack6 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack6 <= stack5;
			elsif (Q='1' and read0='1') then
				stack6 <= stack7;
			end if;
		end if;
	end process;

-- [seventh stack]
	process (clk,reset) begin
		if (reset='1') then
			stack7 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack7 <= stack6;
			elsif (Q='1' and read0='1') then
				stack7 <= stack8;
			end if;
		end if;
	end process;

-- [eighth stack]
	process (clk,reset) begin
		if (reset='1') then
			stack8 <= "0000000000000";
		elsif (clk'event and clk='1') then
			if (Q='1' and write0='1') then
				stack8 <= stack7;
			elsif (Q='1' and read0='1') then
				stack8 <= "0000000000000";
			end if;
		end if;
	end process;	
end RTL;