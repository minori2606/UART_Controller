--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:30:09 12/10/2010
-- Design Name:   
-- Module Name:   C:/My_Works/ise/101210_pic16f877_for_ultrasonic/tb_pic16femu.vhd
-- Project Name:  101210_pic16f877_for_ultrasonic
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pic16femu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_pic16femu IS
END tb_pic16femu;
 
ARCHITECTURE behavior OF tb_pic16femu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pic16femu
    PORT(
         EXTCLK : IN  std_logic;
         swin : IN  std_logic;
         resw : IN  std_logic;
         portain : IN  std_logic_vector(7 downto 0);
         portbin : IN  std_logic_vector(7 downto 0);
         portcin : IN  std_logic_vector(7 downto 0);
         portdin : IN  std_logic_vector(7 downto 0);
         portein : IN  std_logic_vector(7 downto 0);
         portaout : OUT  std_logic_vector(7 downto 0);
         portbout : OUT  std_logic_vector(7 downto 0);
         portcout : OUT  std_logic_vector(7 downto 0);
         portdout : OUT  std_logic_vector(7 downto 0);
         porteout : OUT  std_logic_vector(7 downto 0);
         ext_data_in1 : IN  std_logic_vector(7 downto 0);
         ext_data_in2 : IN  std_logic_vector(7 downto 0);
         debug_ram_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal EXTCLK : std_logic := '0';
   signal swin : std_logic := '0';
   signal resw : std_logic := '0';
   signal portain : std_logic_vector(7 downto 0) := (others => '0');
   signal portbin : std_logic_vector(7 downto 0) := (others => '0');
   signal portcin : std_logic_vector(7 downto 0) := (others => '0');
   signal portdin : std_logic_vector(7 downto 0) := (others => '0');
   signal portein : std_logic_vector(7 downto 0) := (others => '0');
   signal ext_data_in1 : std_logic_vector(7 downto 0) := (others => '0');
   signal ext_data_in2 : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal portaout : std_logic_vector(7 downto 0);
   signal portbout : std_logic_vector(7 downto 0);
   signal portcout : std_logic_vector(7 downto 0);
   signal portdout : std_logic_vector(7 downto 0);
   signal porteout : std_logic_vector(7 downto 0);
   signal debug_ram_out : std_logic_vector(31 downto 0);

   constant EXTCLK_period : time := 1ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pic16femu PORT MAP (
          EXTCLK => EXTCLK,
          swin => swin,
          resw => resw,
          portain => portain,
          portbin => portbin,
          portcin => portcin,
          portdin => portdin,
          portein => portein,
          portaout => portaout,
          portbout => portbout,
          portcout => portcout,
          portdout => portdout,
          porteout => porteout,
          ext_data_in1 => ext_data_in1,
          ext_data_in2 => ext_data_in2,
          debug_ram_out => debug_ram_out
        );
 
 
 
   EXTCLK_process :process
   begin
		EXTCLK <= '0';
		wait for EXTCLK_period/2;
		EXTCLK <= '1';
		wait for EXTCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
		resw <= '0';
		ext_data_in1 <= X"59";
      wait for EXTCLK_period*10;
		resw <= '0';
		swin <= '1';

      -- insert stimulus here 

      wait;
   end process;

END;
