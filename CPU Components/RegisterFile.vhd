----------------------------------------------------------------------------------
-- Engineer:   Donny Percivalle & Alvin Ng
--
-- Create Date:    2/7/2013
-- Design Name:
-- Module Name:   RAT Register File
-- Description:   This is the register block of memory for the RAT
--                microprocessor.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegisterFile is
    Port (  REG_mux_sel : in     STD_LOGIC_VECTOR (1 downto 0);
                IN_port : in     STD_LOGIC_VECTOR (7 downto 0);
                TRI_bus : in     STD_LOGIC_VECTOR (7 downto 0);
                ALU_sum : in     STD_LOGIC_VECTOR (7 downto 0);
                 DX_OUT : inout  STD_LOGIC_VECTOR (7 downto 0);
                 DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
                 ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
                 ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
                 DX_OE  : in     STD_LOGIC;
                 WE     : in     STD_LOGIC;
                 CLK    : in     STD_LOGIC);
end RegisterFile;

architecture Behavioral of RegisterFile is
   TYPE memory is array (0 to 31) of std_logic_vector(7 downto 0);
   SIGNAL REG: memory := (others=>(others=>'0'));

   SIGNAL D_IN : STD_LOGIC_VECTOR (7 downto 0);
begin
   --MUX Select
      process (REG_mux_sel, IN_port, tri_bus, ALU_sum) begin
      if (REG_mux_sel = "00") then
         D_IN <= IN_port;
      elsif (REG_mux_sel = "01") then
         D_IN <= TRI_bus;
      elsif (REG_mux_sel = "10") then
         D_IN <= ALU_sum;
      else
         D_IN <= (others => '0');
      end if;
   end process;

   --REGISTER FILE PROCESS
   process (clk) begin
      if (rising_edge(clk)) then
           if (WE = '1') then
               REG(conv_integer(ADRX)) <= D_IN;
           end if;
      end if;
   end process;

   process (DX_OE, ADRX) begin
      if (DX_OE = '1') then
         DX_OUT <= REG(conv_integer(ADRX));
      else
         DX_OUT <= (others => 'Z');
      end if;
   end process;
   DY_OUT <= REG(conv_integer(ADRY));
end Behavioral;
