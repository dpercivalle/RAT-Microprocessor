----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:22 11/07/2012 
-- Design Name: 
-- Module Name:    PS2_REGISTER - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PS2_REGISTER is
   PORT (
	   PS2_DATA_READY,
      PS2_ERROR		      : out STD_LOGIC;  --will go high once data is served
		PS2_KEY_CODE         : out STD_LOGIC_VECTOR(7 downto 0);   --the byte from keyboard
		PS2_CLK              : inout STD_LOGIC;  --THE KEYBOARD ALWAYS drives the clock
		PS2_DATA             : in STD_LOGIC;
      PS2_CLEAR_DATA_READY : in STD_LOGIC;  --active high, high makes a reset
		CLK : in STD_LOGIC
   );
end PS2_REGISTER;

architecture Behavioral of PS2_REGISTER is

   signal reg   : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
	signal count : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
   signal flipReg: STD_LOGIC_VECTOR(7 downto 0);
	signal isParityCorrect : STD_LOGIC;
		
begin


-- the vector "flipReg" is reg(9 downto 2) reversed
flipReg <= reg(2) & reg(3) & reg(4) & reg(5) & reg(6) & reg(7) & reg(8) & reg(9);

PS2_KEY_CODE <= flipReg;
   
PS2_ERROR <= ((reg(10))   or (not reg(0)) or (not isParityCorrect));  
--           (start bit) or (stop bit)   or (parity)

isParityCorrect <= reg(1) xor reg(2) xor reg(3) xor reg(4) xor reg(5) xor reg(6) xor reg(7) xor reg(8) xor reg(9);  
	                                        --reg(10) is a start bit, reg(0) stop bit
	                                        --reg(10) should be low 
														 --reg(0)  should be high
														 --reg(1)  is the parity bit
														 --   these ps2 key boards use odd parity, so if theres an even
														 --   number of 1's then a 1 will be sent as the parity,
                                           --   the total number of ones excluding the start and stop	
                                           --   should be an odd number														 
														 --if I xor all the data bits together with the parity, it 
														 --should come out as a 1. 
														 --all together: the data is ready when I have a correct 
														 --stop bit, start bit, and parity bit

PS2_DATA_READY <= count(10);

	pauseKeyboard: process (count, PS2_CLEAR_DATA_READY) is
	begin
	   if ((count(10) = '1')or (PS2_CLEAR_DATA_READY = '1')) then
		   PS2_CLK <= '0';
		else 
		   PS2_CLK <= 'Z';
	   end if;
	end process pauseKeyboard;
	
   shiftRegister: process (PS2_CLK, PS2_CLEAR_DATA_READY ) is
   begin
	   if (PS2_CLEAR_DATA_READY = '1') then
         count <= "00000000000";
			reg <= "00000000000";
	   elsif (falling_edge(PS2_CLK)) then
		   reg   <= reg   (9 downto 0) & PS2_DATA;
			count <= count (9 downto 0) & '1';
      end if;
	end process shiftRegister;
	
end Behavioral;

