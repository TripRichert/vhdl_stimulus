--! @file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package to_str_pkg is
  function toStr(val : unsigned) return string;
  function toStr(val : signed) return string;
end package to_str_pkg;
package body to_str_pkg is

  function digitToChar(val : natural) return character is
  begin
    assert val < 10
      report "digit must be less than 10" severity warning;

    return character'val(val + character'pos(character'('0')));
  end function digitToChar;
  
  function toStr(val : unsigned) return string is
    variable tmp : natural;
  begin
    tmp := natural(to_integer(val));
    if val < 10 then
      return string'("") & digitToChar(natural(to_integer(val)));
    end if;
    return toStr(val / 10) & digitToChar(natural(to_integer(val mod 10)));
  end function toStr;
  
  function toStr(val : signed) return string is
    variable tmp : signed(val'length downto 0);
  begin
    tmp := resize(val, val'length + 1);
    if val < 0 then
      return string'("-") & toStr(-tmp);
    else
      return toStr(unsigned(std_ulogic_vector(val)));
    end if;
  end function toStr;

end package body to_str_pkg;
