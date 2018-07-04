library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;
use work.textio_ext.all;


package log_pkg is
  generic (
    type elemType;
    function toStr(val : elemType) return string
    );

  --! writes file line by line, with each tdata being one line
  procedure axiStreamLog(
    constant filename : in string;
    signal   clk      : in  std_ulogic;
    constant edge     : in std_ulogic;--! '1' if rising clk, '0' if falling clk
    signal   tvalid   : in std_ulogic;
    signal   tready   : out  std_ulogic;
    signal   tdata    : in elemType;
    signal   tlast    : in std_ulogic;--! tlast terminates line with semicolon
    signal   close    : in std_ulogic--! '1' when you want to close file
    );
  
end package log_pkg;
    
package body log_pkg is
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
  
  procedure axiStreamLog(
    constant filename : in string;
    signal clk      : in  std_ulogic;
    constant edge   : in std_ulogic;
    signal tvalid   : in std_ulogic;
    signal tready   : out  std_ulogic;
    signal tdata    : in elemType;
    signal tlast    : in std_ulogic;
    signal close    : in std_ulogic
    ) is
    
    file file_handler : text open write_mode is filename;
    variable l        : line;
    variable tmp      : line;
    variable second   : line;
    constant semicolon    : string(1 to 1) := ";";
  begin
    tready <= '0';
    wait until active_edge(clk, edge);
    tready <= '1';
    while close = '0' loop
      if tvalid = '1' then
        write(l, toStr(tdata));
        if tlast = '1' then
          write(l, string'(";"));
        end if;
        writeline(file_handler, l);
      end if;
      wait until active_edge(clk, edge);
    end loop;
    wait;
  end procedure axiStreamLog;
  
end package body log_pkg;
