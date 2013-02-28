----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:19 02/09/2013 
-- Design Name: 
-- Module Name:    Debouncer - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Debouncer is
 port(
  RST : in std_logic;
  CLK : in std_logic;
  INT_IN : in std_logic;
  INT_DEBOUNCED : out std_logic);
end Debouncer;

architecture Behavioral of Debouncer is

signal int_in_debounced: std_logic;
signal cnt : integer;
signal debounced_state : std_logic_vector(2 downto 0);
begin

-------------------------------------------------------------------------------
--This debounces an input signal (interrupt). When the interrupt is received (active high),
--10000 clock cycles are counted. If the interrupt remains high throughout, a two clock-cycle pulse 
--is generated. This is so the control unit won't miss it if it's in its fetch or execute states.
--Note the cnt value can be adjusted as needed.
DEBOUNCER: process(clk, rst) begin
  if rst = '1' then
    cnt <= 0;
	 debounced_state <= "000";
	 int_in_debounced <= '0';
  elsif clk'event and clk = '1' then
    case debounced_state is
	 --In this state, we wait for the interrupt to be asserted.
	    when "000" => 
		    cnt <= 0;
			 int_in_debounced <= '0';
         if (INT_IN = '1') then
	        debounced_state <= "001";
			end if;
		--In this state, we're making sure the interrupt is valid
		  when "001" => 
		   if (INT_IN = '0') then --if the int goes back down to '0' before we're done counting
			   debounced_state <= "000"; --return to the base state
		   elsif (cnt = 10) then --if the int stays high until the max count is reached
			  int_in_debounced <= '1'; --set the debounced interrupt
			  cnt <= 0; --reset the count
			  debounced_state <= "010"; --and move on
			else --keep counting
			  cnt <= cnt + 1;
			end if;
		--In this state, we hold the debounced interrupt for another clock cycle
		  when "010" => --In this state, we hold
		     int_in_debounced <= '1';
			  debounced_state <= "011";
		--In this state, we wait for the interrupt to be deasserted
		  when "011" =>
		      int_in_debounced <= '0';
		      if INT_IN = '0' then --interrupt has been deassertegd
			     debounced_state <= "100";
			   end if;
		  when "100" => 
		   if (INT_IN = '1') then --if the int goes back down to '1' before we're done counting
			   debounced_state <= "011"; --return to the last state
		   elsif (cnt = 10) then --if the int stays high until the max count is reached
			  cnt <= 0; --reset the count
			  debounced_state <= "000"; --return to the beginning
			else --keep counting
			  cnt <= cnt + 1;
			end if;
		  when others =>
		     cnt <= 0;
			  int_in_debounced <= '0';
			  debounced_state <= "000";
	 end case;
  end if;
end process;
INT_DEBOUNCED <= int_in_debounced;
end Behavioral;

