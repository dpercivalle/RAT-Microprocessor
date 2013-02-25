----------------------------------------------------------------------------------
-- Engineer: Donny Percivalle & Alvin Ng
--
-- Create Date:    13:51:55 01/24/2013
-- Design Name:
-- Module Name:    ScratchPadMemory - Behavioral
-- Description:    Scratch Pad memory module for the RAT microprocessor.
--                 256x10 bit memory.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ScratchPadMemory is
    Port(IMMED_ADR : in STD_LOGIC_VECTOR (7 downto 0);
            SP_ADR : in STD_LOGIC_VECTOR (7 downto 0);
            RS_ADR : in STD_LOGIC_VECTOR (7 downto 0);
       SCR_ADR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
             SP_WE : in  STD_LOGIC;
             SP_OE : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
           SP_DATA : inout  STD_LOGIC_VECTOR (9 downto 0));
end ScratchPadMemory;

architecture Behavioral of ScratchPadMemory is
   --Define memory type, 256x10
   TYPE memory is array (0 to 255) of STD_LOGIC_VECTOR (9 downto 0);
   signal mem : memory := (others=>(others=>'0'));
   signal SP_ADRS : STD_LOGIC_VECTOR (7 downto 0);
begin

   --Scratch Pad Address Multiplexer
   process (IMMED_ADR, SP_ADR, RS_ADR, SCR_ADR_SEL) begin
      case (SCR_ADR_SEL) is
         when "00" =>
            SP_ADRS <= IMMED_ADR;
         when "01" =>
            SP_ADRS <= SP_ADR;
         when "10" =>
            SP_ADRS <= (SP_ADR - 1);
         when "11" =>
            SP_ADRS <= RS_ADR;
         when others =>
            SP_ADRS <= (others => '0');
      end case;
   end process;

   --Writing clocked process
   process (clk, SP_DATA, SP_ADRS) begin
      if (rising_edge(clk)) then
         if (SP_WE = '1') then
            mem(conv_integer(SP_ADRS)) <= SP_DATA;
         end if;
      end if;
   end process;
   --Asynchronous reading (output) process
   SP_DATA <= mem(conv_integer(SP_ADRS)) when (SP_OE = '1') else (others => 'Z');
end Behavioral;
