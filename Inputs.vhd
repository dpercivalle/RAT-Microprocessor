----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    1/31/2012
-- Design Name:
-- Module Name:    RAT_wrapper - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description: Since the RAT can only accept one input at a time, this module
--              muxes all inputs, selecting the active one via the port_id.
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

entity inputs is
    Port ( input_port : out   STD_LOGIC_VECTOR (7 downto 0);  --the input corresponding to the port_id
           switches   : in    STD_LOGIC_VECTOR (7 downto 0);  --the current value of the switches on the Nexsys board
           pixelData  : in    STD_LOGIC_VECTOR (7 downto 0);  --value at pixel location from frame buffer
           port_id    : in    STD_LOGIC_VECTOR (7 downto 0)); --the currently active port_id
end inputs;

architecture Behavioral of inputs is
-- INPUT PORT IDS -------------------------------------------------------------
-- Right now, the only possible inputs are the switches
-- In future labs you can add more port IDs, and you'll have
-- to add constants here for the mux below
-- Once you do that, remove this comment.
CONSTANT SWITCHES_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
CONSTANT VGA_READ_ID : STD_LOGIC_VECTOR (7 downto 0) := X"30";

begin
-- Mux for selecting what input to read -----------------------------------
  process(port_id, switches, pixelData)
    begin
      case (port_id) is
        when SWITCHES_ID => input_port <= switches;
        when VGA_READ_ID => input_port <= pixelData;
        when others      => input_port <= x"00";
      end case;
  end process;
-------------------------------------------------------------------------------
end Behavioral;
