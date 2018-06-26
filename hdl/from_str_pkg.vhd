--! @file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package from_str_pkg is
  function strToUnsigned(val : string; len : natural) return unsigned;
  function strToSigned(val : string; len : natural) return signed;
  function strToInt(val : string) return integer;
  function strToNat(val : string) return natural;
end package from_str_pkg;

package body from_str_pkg is

  function toDigit(c : character) return natural is
  begin
    return character'pos(c) - character'pos(character'('0'));
  end function toDigit;

  function strToUnsigned(val : string; len : natural) return unsigned is
    variable retVal : unsigned(len - 1 downto 0) := (others => '0');
    variable tmp : integer;
  begin
    for i in val'right downto val'left loop
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
    left := val'left;
    if val(val'left) = '-' then
      neg := true;
      left := left + 1;
    else
      neg := false;
    end if;
    for i in val'right downto left loop
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
