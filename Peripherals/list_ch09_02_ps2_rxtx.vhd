--
-- A wrapper module to control communication with a PS/2 device
--
--





-- Listing 9.2
library ieee;
use ieee.std_logic_1164.all;
entity ps2_rxtx is
   port (
      clk, reset: in std_logic;
      wr_ps2: in std_logic;
      din: in std_logic_vector(7 downto 0);
      dout: out std_logic_vector(7 downto 0);
      rx_done_tick: out  std_logic;
      tx_done_tick: out std_logic;
      ps2d, ps2c: inout std_logic
   );
end ps2_rxtx;

architecture arch of ps2_rxtx is


component ps2_tx is
   port (
      clk, reset: in  std_logic;
      din: in std_logic_vector(7 downto 0);

      wr_ps2 : in std_logic;
      ps2d, ps2c: inout std_logic;
      tx_idle: out std_logic;
      tx_done_tick: out std_logic
   );
end component;
component ps2_rx is
   port (
      clk, reset: in  std_logic;
      ps2d, ps2c: in  std_logic;  -- key data, key clock

      rx_en: in std_logic;
      rx_done_tick: out  std_logic;
      dout: out std_logic_vector(7 downto 0)
   );
end component;

signal tx_idle: std_logic;
signal rx_done_reg, rx_done_reg_reg : std_logic;

begin
   ps2_tx_unit: ps2_tx
      port map(clk=>clk, reset=>reset, wr_ps2=>wr_ps2,
               din=>din, ps2d=>ps2d, ps2c=>ps2c,
               tx_idle=>tx_idle, tx_done_tick=>tx_done_tick);
   ps2_rx_unit: ps2_rx
      port map(clk=>clk, reset=>reset, rx_en=>tx_idle,
               ps2d=>ps2d, ps2c=>ps2c,
               rx_done_tick=>rx_done_reg, dout=>dout);

--    process (clk, rx_done_reg) begin
--       if (rising_edge(clk)) then
--          rx_done_reg_reg <= rx_done_reg;
--       end if;
--    end process;

   rx_done_tick <= (rx_done_reg);
end arch;
