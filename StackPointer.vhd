----------------------------------------------------------------------------------
-- Engineer: Donny Percivalle & Alvin Ng
--
-- Create Date:    13:00:36 02/12/2013
-- Module Name:    StackPointer - Behavioral
-- Description:    Stack pointer for the RAT microprocessor.
--                 LIFO architecture.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StackPointer is
    Port ( INC_DEC : in  STD_LOGIC_VECTOR (1 downto 0);
              D_IN : in  STD_LOGIC_VECTOR (7 downto 0);
                WE : in  STD_LOGIC;
               RST : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
          STK_PNTR : out  STD_LOGIC_VECTOR (7 downto 0));
end StackPointer;

architecture Behavioral of StackPointer is

signal pointer : STD_LOGIC_VECTOR (7 downto 0);

begin

   process (RST, CLK, D_IN, INC_DEC, WE) begin
      --ASYNCRONOUS RESET
      if (RST = '1') then
         pointer <= (others => '0');
      --SYNCHRONOUS POINTER BEHAVIOR
      elsif (rising_edge(CLK)) then
         if (WE = '1') then
            pointer <= D_IN;
         else
            case (INC_DEC) is
               when "00" | "11" => --HOLD
                  pointer <= pointer;
               when "01" => --DECREMENT
                  pointer <= pointer - 1;
               when "10" => --INCREMENT
                  pointer <= pointer + 1;
               when others =>
                  pointer <= pointer;
            end case;
         end if;
      end if;
     end process;
     STK_PNTR <= pointer;

end Behavioral;

