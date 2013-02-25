----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    1/31/2012
-- Design Name:
-- Module Name:    outputs - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description: Decodes the port_id and sets the current output value on the correct port
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

entity outputs is
    Port ( leds     : out   STD_LOGIC_VECTOR (7 downto 0); --output to the board leds
           port_id  : in    STD_LOGIC_VECTOR (7 downto 0); --id of the currently active port
       output_port  : in    STD_LOGIC_VECTOR (7 downto 0); -- current value of the output
           io_oe    : in    STD_LOGIC; --indication that the output can be transmitted
           clk      : in    STD_LOGIC);
end outputs;

architecture Behavioral of outputs is
-------------------------------------------------------------------------------
-- OUTPUT PORT IDS ------------------------------------------------------------
-- In future labs you can add more port IDs
-- (and remove this comment)
CONSTANT LEDS_ID : STD_LOGIC_VECTOR (7 downto 0) := X"40";
-------------------------------------------------------------------------------

begin

-- Mux for updating outputs -----------------------------------------------
--Note that outputs are updated on the rising edge of the clock, when
--the io_oe signal is asserted
OUTPUTS: process(clk) begin
  if clk'event and clk = '1' then
    if (io_oe = '1') then
      case (port_id) is
        when LEDS_ID => LEDS <= output_port;
        when others  => LEDS <= X"00";

      end case;
    end if;
  end if;
end process OUTPUTS;

-------------------------------------------------------------------------------

end Behavioral;
