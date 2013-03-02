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
           sseg     : out   STD_LOGIC_VECTOR (7 downto 0); --output to sseg segments
           vga_wa   : out   STD_LOGIC_VECTOR (10 downto 0); --VGA write address
           vga_wd   : out   STD_LOGIC_VECTOR (7 downto 0); --VGA write data
           vga_we   : out   STD_LOGIC; --VGA write enable
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
CONSTANT SSEG_ID : STD_LOGIC_VECTOR (7 downto 0) := X"80";
CONSTANT VGA_HADDR : STD_LOGIC_VECTOR (7 downto 0) := X"55";
CONSTANT VGA_LADDR : STD_LOGIC_VECTOR (7 downto 0) := X"66";
CONSTANT VGA_WRITE : STD_LOGIC_VECTOR (7 downto 0) := X"77";
-------------------------------------------------------------------------------

begin

-- Mux for updating outputs -----------------------------------------------
--Note that outputs are updated on the rising edge of the clock, when
--the io_oe signal is asserted
OUTPUTS: process(clk, output_port, port_id) begin
  if (rising_edge(clk)) then
    if (io_oe = '1') then
      case (port_id) is
        when LEDS_ID => LEDS <= output_port;
        when SSEG_ID => SSEG <= output_port;
        when VGA_HADDR => vga_wa (10 downto 8) <= output_port (2 downto 0);
        when VGA_LADDR => vga_wa (7 downto 0) <= output_port;
        when VGA_WRITE => vga_wd <= output_port;
        when others  => null;
      end case;

      if (port_id = VGA_WRITE) then
         vga_we <= '1';
      else
         vga_we <= '0';
      end if;
    end if;
  end if;
end process OUTPUTS;
-------------------------------------------------------------------------------
end Behavioral;