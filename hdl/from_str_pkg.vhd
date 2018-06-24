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
  function strToUnsigned(val : string; len : natural) return unsigned is
  begin
    return to_unsigned(1, len);
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
