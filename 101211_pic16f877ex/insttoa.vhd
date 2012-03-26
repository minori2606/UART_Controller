----------------------------------------------------------------------------------
-- Company: Sasebo National College of Technology
-- Engineer: 
-- 
-- Create Date:    14:39:33 09/26/2009 
-- Design Name: 
-- Module Name:    insttoa - Behavioral 
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
use work.LCD_PAC.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity insttoa is
	port(
		INST_PIC : in std_logic_vector(31 downto 0);
		INST_ASC : out std_logic_vector(47 downto 0)
	);
end insttoa;

architecture Behavioral of insttoa is

begin
	process(INST_PIC) begin
		case INST_PIC is
			when X"00000000" => INST_ASC <= ch_space & ch_space & ch_space & ch_cn & ch_co & ch_cp;

			when X"00000001" => INST_ASC <= ch_space & ch_ca & ch_cd & ch_cd & ch_cw & ch_cf;
			when X"00000002" => INST_ASC <= ch_space & ch_ca & ch_cn & ch_cd & ch_cw & ch_cf;
			when X"00000004" => INST_ASC <= ch_space & ch_space & ch_cc & ch_cl & ch_cr & ch_cf;
			when X"00000008" => INST_ASC <= ch_space & ch_space & ch_cc & ch_cl & ch_cr & ch_cw;
			when X"00000010" => INST_ASC <= ch_space & ch_space & ch_cc & ch_co & ch_cm & ch_cf;

			when X"00000020" => INST_ASC <= ch_space & ch_space & ch_cd & ch_ce & ch_cc & ch_cf;
			when X"00000040" => INST_ASC <= ch_cd & ch_ce & ch_cc & ch_cf & ch_cs & ch_cz;
			when X"00000080" => INST_ASC <= ch_space & ch_space & ch_ci & ch_cn & ch_cc & ch_cf;
			when X"00000100" => INST_ASC <= ch_ci & ch_cn & ch_cc & ch_cf & ch_cs & ch_cz;
			when X"00000200" => INST_ASC <= ch_space & ch_ci & ch_co & ch_cr & ch_cw & ch_cf;

			when X"00000400" => INST_ASC <= ch_space & ch_space & ch_cm & ch_co & ch_cv & ch_cf;
			when X"00000800" => INST_ASC <= ch_space & ch_cm & ch_co & ch_cv & ch_cw & ch_cf;
			when X"00001000" => INST_ASC <= ch_space & ch_space & ch_space & ch_cr & ch_cl & ch_cf;
			when X"00002000" => INST_ASC <= ch_space & ch_space & ch_space & ch_cr & ch_cr & ch_cf;
			when X"00004000" => INST_ASC <= ch_space & ch_cs & ch_cu & ch_cb & ch_cw & ch_cf;

			when X"00008000" => INST_ASC <= ch_space & ch_cs & ch_cw & ch_ca & ch_cp & ch_cf;
			when X"00010000" => INST_ASC <= ch_space & ch_cx & ch_co & ch_cr & ch_cw & ch_cf;
			when X"00020000" => INST_ASC <= ch_space & ch_space & ch_space & ch_cb & ch_cc & ch_cf;
			when X"00040000" => INST_ASC <= ch_space & ch_space & ch_space & ch_cb & ch_cs & ch_cf;
			when X"00080000" => INST_ASC <= ch_space & ch_cb & ch_ct & ch_cf & ch_cs & ch_cc;

			when X"00100000" => INST_ASC <= ch_space & ch_cb & ch_ct & ch_cf & ch_cs & ch_cs;
			when X"00200000" => INST_ASC <= ch_space & ch_ca & ch_cn & ch_cd & ch_cl & ch_cw;
			when X"00400000" => INST_ASC <= ch_space & ch_space & ch_cc & ch_ca & ch_cl & ch_cl;
			when X"00800000" => INST_ASC <= ch_space & ch_space & ch_cg & ch_co & ch_ct & ch_co;
			when X"01000000" => INST_ASC <= ch_space & ch_ci & ch_co & ch_cr & ch_cl & ch_cw;

			when X"02000000" => INST_ASC <= ch_space & ch_cm & ch_co & ch_cv & ch_cl & ch_cw;
			when X"04000000" => INST_ASC <= ch_co & ch_cp & ch_ct & ch_ci & ch_co & ch_cn;
			when X"08000000" => INST_ASC <= ch_space & ch_cr & ch_ce & ch_ct & ch_cl & ch_cw;
			when X"10000000" => INST_ASC <= ch_space & ch_space & ch_ct & ch_cr & ch_ci & ch_cs;
			when X"20000000" => INST_ASC <= ch_space & ch_cx & ch_co & ch_cr & ch_cl & ch_cw;

			when others => INST_ASC <= ch_blank & ch_blank & ch_blank & ch_blank & ch_blank & ch_blank;
		end case;
	end process;

end Behavioral;

