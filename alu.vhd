----------------------------------------------------------------------------------
-- Engineer: Donny Percivalle & Alvin Ng
--
-- Create Date:    14:10:09 01/29/2013
-- Module Name:    ArithmeticLogicUnitBehavorial - Behavioral
-- Description:    Arithmetic logic unit for RAT microprocessor
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (    A : in  STD_LOGIC_VECTOR (7 downto 0);
           C_in : in  STD_LOGIC;
         REG_in : in  STD_LOGIC_VECTOR (7 downto 0);
          IMMED : in  STD_LOGIC_VECTOR (7 downto 0);
        MUX_SEL : in  STD_LOGIC;
            SEL : in  STD_LOGIC_VECTOR (3 downto 0);
            SUM : out  STD_LOGIC_VECTOR (7 downto 0);
         C_FLAG : out  STD_LOGIC;
         Z_FLAG : out  STD_LOGIC);
end ALU;

architecture ALU_a of ALU is
   signal C_sig : std_logic;
   signal B, sum_sig : std_logic_vector (7 downto 0);

   begin



   --MUX DETERMINE B OPERAND

   process (MUX_SEL) begin
      if (MUX_SEL = '0') then
         B <= REG_in;
      elsif (MUX_SEL = '1') then
         B <= IMMED;
      else
         B <= (others => '0');
      end if;
   end process;

   --INSTRUCTION SET
   process (SEL, A, B, C_in, C_sig)
      --Create a variable for answer so that we can can sum and C_Flag from it
      variable answer : std_logic_vector (8 downto 0);
      begin

         case(SEL) is

               --ADD Operation
                     when "0000" =>
                        answer := ('0'& A) + ('0'& B);
                        C_sig <= answer(8);

               --ADDC Operation
                     when "0001" =>
                        answer := ('0'& A) + ('0'& B) + C_In;
                        C_sig <= answer(8);

               --CMP Operation
                     when "0010" =>
                        answer := ('0' & A) - ('0' & B);
                        C_sig <= answer(8);

               --SUB Operation
                     when "0011" =>
                        answer := ('0'& A) - ('0' & B);
                        C_sig <= answer(8);

               --SUBC Operation
                     when "0100" =>
                        answer := ('0'& A) - ('0' & B) - C_In;
                        C_sig <= answer(8);

               --AND Operation
                     when "0101" =>
                        answer:= ('0'& A) AND ('0'& B);
                        C_sig <= C_in;
               --ASR Operation
                     when "0110" =>
                        answer := ('0'& A(7)) & (A(7 downto 1));
                        C_sig <= A(0);

               -- EXOR Operation
                     when "0111" =>
                        answer := ('0' & A) XOR ('0' & B);
                        C_sig <= C_in;

               -- LSL Operation
                     when "1000" =>
                        answer := ('0' & A(6 downto 0)) & (C_in);
                        C_sig <= A(7);

               -- LSR Operation
                     when "1001" =>
                        answer := '0' & C_in & A(7 downto 1);
                        C_sig <= A(0);

               -- OR Operation
                     when "1010" =>
                        answer := '0' & (A OR B);
                        C_sig <= C_in;

               -- ROL Operation
                     when "1011" =>
                        answer := '0' & A(6 downto 0) & A(7);
                        C_sig <= A(7);

               -- ROR Operation
                     when "1100" =>
                        answer := '0' & A(0) & A(7 downto 1);
                        C_sig <= A(0);

               -- TEST Operation
                     when "1101" =>
                        answer := '0'& A AND '0'& B;
                        C_sig <= C_in;

               -- MOV Operation
                     when "1110" =>
                        answer := '0' & B;
                        C_sig <= C_in;

                     when others =>
                        answer := (others => '0');
                        C_sig <= C_in;
         end case;
         SUM     <= answer (7 downto 0);
         sum_sig <= answer (7 downto 0);
         C_FLAG <= C_sig;

      end process;

      process (sum_sig) begin
         --UPDATE the Z_FLAG in response to the current answer
         if (sum_sig = "00000000") then
            Z_FLAG <= '1';
         else
            Z_FLAG <= '0';
         end if;
      end process;

end ALU_a;
