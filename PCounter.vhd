----------------------------------------------------------------------------------
-- Engineer: DONNY PERCIVALLE & ALVIN NG
--
-- Create Date:    13:43:47 01/15/2013
-- Design Name:
-- Module Name:    PCounter - Behavioral
-- Description: Program counter component to be used in the RAT microprocessor
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter is
    PORT(
         CLK        : IN  std_logic;
         RST        : IN  std_logic;
         LOAD       : IN  std_logic;
         OE         : IN  std_logic;
         SEL        : IN  std_logic_vector(1 downto 0);
         FROM_IMMED : IN  std_logic_vector(9 downto 0);
         FROM_STACK : IN  std_logic_vector(9 downto 0);
         PC_COUNT   : OUT  std_logic_vector(9 downto 0);
         PC_TRI     : INOUT  std_logic_vector(9 downto 0));
end program_counter;

architecture Behavioral of program_counter is

signal count : STD_LOGIC_VECTOR (9 downto 0);

begin
   process (CLK, RST) begin
      if (RST = '1') then
         count <= (others => '0');
      elsif (rising_edge(CLK)) then
            --NORMAL PC OPERATION, INCREMENT COUNT BY 1
            if (SEL = "00") then
               if (LOAD = '1') then
                  count <= count + 1;
               end if;
            --OUTPUT ADDRESS FROM INSTRUCTION
            elsif (SEL = "01") then
               count <= FROM_IMMED;

            --OUTPUT ADDRESS FROM PC_TRI
            elsif (SEL = "10") then
               count <= FROM_STACK;

            --INTERRUPT
            else
               count <= "1111111111";
            end if;
      end if;
   end process;

   PC_COUNT <= count;
   PC_TRI <= count when (OE = '1') else (others => 'Z');


end Behavioral;

