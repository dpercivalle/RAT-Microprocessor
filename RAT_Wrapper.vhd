----------------------------------------------------------------------------------
-- Engineer:   Donny Percivalle & Alvin Ng
--
-- Create Date:    1/25/2013
-- Design Name:
-- Module Name:    RAT_wrapper - Behavioral
-- Description: This is the top-level RAT wrapper, which instantiates the
-- the microprocessor itself, and the I/O blocks that interface with the
-- rest of the board
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAT_wrapper is
    Port ( leds     : out   STD_LOGIC_VECTOR (7 downto 0);
           switches : in    STD_LOGIC_VECTOR (7 downto 0);
           rst      : in    STD_LOGIC;
           clk      : in    STD_LOGIC);
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is

-- Declare RAT_CPU ------------------------------------------------------------
component RAT_CPU
    Port ( in_port  : in  STD_LOGIC_VECTOR (7 downto 0);
           out_port : out STD_LOGIC_VECTOR (7 downto 0);
           port_id  : out STD_LOGIC_VECTOR (7 downto 0);
           rst      : in  STD_LOGIC;
           io_oe    : out STD_LOGIC;
           int_in   : in  STD_LOGIC;
           clk      : in  STD_LOGIC);
end component RAT_CPU;

component inputs is
    Port ( input_port : out   STD_LOGIC_VECTOR (7 downto 0);
           switches   : in    STD_LOGIC_VECTOR (7 downto 0);
           port_id    : in    STD_LOGIC_VECTOR (7 downto 0));
end component;

component outputs is
    Port ( leds         : out   STD_LOGIC_VECTOR (7 downto 0);
           port_id      : in    STD_LOGIC_VECTOR (7 downto 0);
           output_port  : in    STD_LOGIC_VECTOR (7 downto 0);
           io_oe        : in    STD_LOGIC;
           clk          : in    STD_LOGIC);
end component;
-------------------------------------------------------------------------------

-- Signals for connecting RAT_CPU to RAT_wrapper -------------------------------

signal input_port  : std_logic_vector (7 downto 0);
signal output_port : std_logic_vector (7 downto 0);
signal port_id     : std_logic_vector (7 downto 0);
signal io_oe       : std_logic;

-------------------------------------------------------------------------------

begin

-- Instantiate RAT_CPU --------------------------------------------------------

CPU: RAT_CPU
  port map(in_port  => input_port,
           out_port => output_port,
           port_id  => port_id,
           rst      => rst,
           io_oe    => io_oe,
           int_in   => '0', --FIXME when interrupts are added
           clk      => clk);


-- Instantiate Inputs --------------------------------------------------------

INPUT: inputs
    port map(input_port => input_port,
             switches   => switches,
             port_id    => port_id);



-- Instantiate Outputs --------------------------------------------------------
OUTPUT: outputs
    port map(leds        => leds,
             port_id     => port_id,
             output_port => output_port,
             io_oe       => io_oe,
             clk         => clk);

-------------------------------------------------------------------------------
end Behavioral;
