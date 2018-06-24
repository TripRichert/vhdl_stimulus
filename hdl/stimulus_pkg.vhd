library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;
use work.textio_ext.all;

package stimulus_pkg is
  generic (
    type elemType;
    function fromStr(val : string) return elemType
    );

  
  procedure axiStreamStimulus(
    constant filename : in string;
    signal   clk      : in  std_ulogic;
    constant edge     : in std_ulogic;
    signal   tvalid   : out std_ulogic;
    signal   tready   : in  std_ulogic;
    signal   tdata    : out elemType;
    signal   tlast    : out std_ulogic;
    signal   done     : out std_ulogic
    );
  
end package stimulus_pkg;
    
package body stimulus_pkg is
  function active_edge(signal clk : std_ulogic; edge : std_ulogic)
    return boolean is
  begin
    assert edge = '1' or edge = '0' report "bad edge definition" severity error;
    if edge = '1' then
      return rising_edge(clk);
    else
      return falling_edge(clk);
    end if;
  end function active_edge;
  
  procedure axiStreamStimulus(
    constant filename : in string;
    signal clk      : in  std_ulogic;
    constant edge   : in std_ulogic;
    signal tvalid   : out std_ulogic;
    signal tready   : in  std_ulogic;
    signal tdata    : out elemType;
    signal tlast    : out std_ulogic;
    signal done     : out std_ulogic
    ) is
    
    file file_handler : text open read_mode is filename;
    variable l        : line;
    variable tmp      : line;
    variable second   : line;
    constant semicolon    : string(1 to 1) := ";";
  begin
    done   <= '0';
    tvalid <= '0';
    tlast  <= '0';
    done   <= '0';
    wait until active_edge(clk, edge);
    while not endfile(file_handler) loop
      readline(file_handler, l);
      read(l, tmp, semicolon);
      tdata <= fromStr(tmp.all);
      tvalid <= '1';
      if endfile(file_handler) or (l'length > 0 and l.all(l'left) = ';') then
        tlast <= '1';
      end if;
      wait until active_edge(clk, edge) and tready = '1';
    end loop;
    tlast <= '0';
    done <= '1';
    wait;
  end procedure axiStreamStimulus;
end package body stimulus_pkg;
