library ieee;
use ieee.std_logic_1164.all;

package str_lst_pkg is
  function getLstNumSeg(val : string; delim : string) return natural;
  function getLstSeg(val : string; index : natural; delim : string) return string;
end package str_lst_pkg;

package body str_lst_pkg is
  
  function getLstNumSeg(val : string; delim : string) return natural is
  begin
    return 0;
  end function getLstNumSeg;
  
  function getLstSeg(val : string; index : natural; delim : string) return string is
  begin
    return string'("0");
  end function getLstSeg;
end package body str_lst_pkg;
