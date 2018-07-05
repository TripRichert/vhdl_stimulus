--! @file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! functions to convert data in strings to other types
package from_str_pkg is
  
  function strToUnsigned(
    val : string;
    len : natural--! lenghth of unsigned return vector
    ) return unsigned;
  function strToSigned(
    val : string;
    len : natural--! length of signed return vector
    ) return signed;
  
  function strToInt(val : string) return integer;
  function strToNat(val : string) return natural;
  
end package from_str_pkg;

package body from_str_pkg is

  --! converts character '0' to '9' to natural
  function toDigit(c : character) return natural is
    variable tmp : integer;
  begin
    tmp := character'pos(c) - character'pos(character'('0'));
    assert (tmp >= 0 and tmp <= 9) report "nondigit character" severity error;
    return tmp;
  end function toDigit;

  function strToUnsigned(val : string; len : natural) return unsigned is
    variable retVal : unsigned(len - 1 downto 0) := (others => '0');
    variable tmp : integer;
  begin
    assert val'left <= val'right report "string is wrong direction" severity error;
    for i in val'left to val'right loop
      retVal := resize(retVal * to_unsigned(10, 4), retVal'length);
      retVal := retVal + toDigit(val(i));
    end loop;
    return retVal;
  end function strToUnsigned;

  function strToSigned(val : string; len : natural) return signed is
    variable retVal : signed(len - 1 downto 0) := (others => '0');
    variable left  : integer;
    variable incr   : integer;
    variable neg    : boolean := false;
  begin
    assert val'left <= val'right report "string is wrong direction" severity error;

    --find out of signed value is negative
    left := val'left;
    if val(val'left) = '-' then
      neg := true;
      left := left + 1;
    else
      neg := false;
    end if;

    --compute value
    for i in left to val'right loop
      retVal := resize(retVal * to_signed(10, 5), retVal'length);
      if neg then
        retVal := retVal - toDigit(val(i));
      else
        retVal := retVal + toDigit(val(i));
      end if;
    end loop;
    return retVal;      
  end function strToSigned;
  
  function strToInt(val : string) return integer is
  begin
    return integer'value(val);
  end function strToInt;
  
  function strToNat(val : string) return natural is
    variable retVal : integer;
  begin
    retVal := integer'value(val);
    assert retVal > 0 report "read negative number from file into natural" severity warning;
    return retVal;
  end function strToNat;
  
end package body from_str_pkg;
