--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package RS232C_PAC is

  
--  type <new_type> is
--    record
--        <type_name>        : std_logic_vector( 7 downto 0);
--        <type_name>        : std_logic;
--    end record;

-- Declare constants

subtype byte is std_logic_vector(7 downto 0);
constant ch_cLF : byte := X"0A";
constant ch_cCR : byte := X"0D";
constant ch_space : byte := X"20";
constant ch_excla : byte := X"21";
constant ch_comma : byte := X"2C";
constant ch_blank : byte := X"FF";
constant ch_0 : byte := X"30";
constant ch_1 : byte := X"31";
constant ch_2 : byte := X"32";
constant ch_3 : byte := X"33";
constant ch_4 : byte := X"34";
constant ch_5 : byte := X"35";
constant ch_6 : byte := X"36";
constant ch_7 : byte := X"37";
constant ch_8 : byte := X"38";
constant ch_9 : byte := X"39";
constant ch_colon : byte := X"3A";
constant ch_scolon : byte := X"3B";

constant ch_cC : byte := X"43";
constant ch_cD : byte := X"44";
constant ch_cH : byte := X"48";
constant ch_cL : byte := X"4C";
constant ch_cM : byte := X"4D";
constant ch_cN : byte := X"4E";
constant ch_cR : byte := X"52";
constant ch_cS : byte := X"53";
constant ch_cT : byte := X"54";
constant ch_cW : byte := X"57";
constant ch_a : byte := X"61";
constant ch_b : byte := X"62";
constant ch_c : byte := X"63";
constant ch_d : byte := X"64";
constant ch_e : byte := X"65";
constant ch_f : byte := X"66";
constant ch_g : byte := X"67";
constant ch_h : byte := X"68";
constant ch_i : byte := X"69";
constant ch_j : byte := X"6A";
constant ch_k : byte := X"6B";
constant ch_l : byte := X"6C";
constant ch_m : byte := X"6D";
constant ch_n : byte := X"6E";
constant ch_o : byte := X"6F";
constant ch_p : byte := X"70";
constant ch_q : byte := X"71";
constant ch_r : byte := X"72";
constant ch_s : byte := X"73";
constant ch_t : byte := X"74";
constant ch_u : byte := X"75";
constant ch_v : byte := X"76";
constant ch_w : byte := X"77";
constant ch_x : byte := X"78";
constant ch_y : byte := X"79";
constant ch_z : byte := X"80";
  
-- Declare functions and procedure

--  function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
--  procedure <procedure_name>	(<type_declaration> <constant_name>	: in <type_declaration>);

end RS232C_PAC;


--package body RS232C_PAC is
--
---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;
--
--
---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;
--
---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
-- 
--end RS232C_PAC;
