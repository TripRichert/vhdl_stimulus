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
  begin
    return to_signed(1, len);
  end function strToSigned;
  function strToInt(val : string) return integer is
  begin
    return 0;
  end function strToInt;
  function strToNat(val : string) return natural is
  begin
    return 0;
  end function strToNat;
  
end package body from_str_pkg;
