library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;

--! reads ctrl file. Two numbers per line. Allows data to flow for first number
--clock cycles, then blocks for second number clock cycles.
--once all lines of file are read, repeats.
entity axistream_flowctrl is
  generic (
    edge : std_ulogic := '1';--! '1' for rising clk, '0' for falling
    ctrl_filename : string
    );
  port (
    clk         : in std_ulogic;
    src_tvalid  : in std_ulogic;
    src_tready  : out std_ulogic;
    src_tlast   : in  std_ulogic;
    dest_tvalid : out std_ulogic;
    dest_tready : out std_ulogic;
    dest_tlast  : out std_ulogic;
    closeFile   : in  std_ulogic
    );
end entity axistream_flowctrl;

architecture behavioral of axistream_flowctrl is
  function active_edge(signal clk : std_ulogic; edge : std_ulogic)
    return boolean is
  begin
    assert edge = '1' or edge = '0'
      report "bad edge definition" severity error;
    
    if edge = '1' then
      return rising_edge(clk);
    else
      return falling_edge(clk);
    end if;
  end function active_edge;

  signal allow_flow : boolean := false;
begin
  dest_tvalid <= src_tvalid when allow_flow else '0';
  src_tready <= dest_tready when allow_flow else '0';
  dest_tlast <= src_tlast when allow_flow else '0';
  
  process
    file file_handler : text;
    variable l : line;
    variable go : natural;
    variable noGo : natural;
  begin
    file_open(file_handler, ctrl_filename, READ_MODE);
    while not endfile(file_handler) loop
      readline(file_handler, l);
      read(l, go);
      read(l, noGo);
      allow_flow <= true;
      --allow data flow for go clock cycles
      for i in 0 to go loop
        wait until active_edge(clk, edge);
      end loop;
      --block data file for noGo clock cycles
      allow_flow <= false;
      for i in 0 to noGo loop
        wait until active_edge(clk, edge);
      end loop;
      if closeFile = '1' then
        wait;
      end if;
    end loop;
    file_close(file_handler);
    --Repeats!
  end process;
end architecture behavioral;
