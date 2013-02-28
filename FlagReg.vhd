-- 
-- A flip-flop to store the the zero, carry, and interrupt flags.
-- To be used in the RAT CPU.
-- 
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FlagReg is
    Port ( IN_FLAG  : in  STD_LOGIC; --flag input
           LD       : in  STD_LOGIC; --load the out_flag with the in_flag value
           SET      : in  STD_LOGIC; --set the flag to '1'
           CLR      : in  STD_LOGIC; --clear the flag to '0'
           RESTORE  : in  STD_LOGIC; --interrupt complete; restore flag from shadow
           SAVE     : in  STD_LOGIC; --interrupt received; store flag into shadow
           CLK      : in  STD_LOGIC; --system clock
           OUT_FLAG : out  STD_LOGIC); --flag output
end FlagReg;

architecture Behavioral of FlagReg is
signal out_flag_i : std_logic := '0';
signal shadow_flag_i : std_logic := '0';
begin
    process(CLK) begin
        if( rising_edge(CLK) ) then
            if( LD = '1' ) then
                out_flag_i <= IN_FLAG;
            elsif( SET = '1' ) then
                out_flag_i <= '1';
            elsif( CLR = '1' ) then
                out_flag_i <= '0';
	         elsif(RESTORE = '1') then
                out_flag_i <= shadow_flag_i;
	         end if;
         end if;
    end process;		

    process(CLK) begin
        if( rising_edge(CLK) ) then
          if SAVE = '1' then
            shadow_flag_i <= out_flag_i;
	       end if;
	     end if;
    end process;

OUT_FLAG <= out_flag_i;	 
end Behavioral;

