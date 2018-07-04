library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.str_lst_pkg.all;
use work.from_str_pkg.all;
use work.to_str_pkg.all;

package numericstd_array_str_pkg is
    generic (
      constant elemPerLine : natural := 2;
      constant bitsPerElem : natural := 4
      );

    type unsigned_arr is array(elemPerLine - 1 downto 0) of unsigned(bitsPerElem - 1 downto 0);
    type signed_arr is array(elemPerLine - 1 downto 0) of signed(bitsPerElem - 1 downto 0);

    function fromStrToUnsignedArray(val : string) return unsigned_arr;
    function fromStrToSignedArray(val : string) return signed_arr;
    function toStr(val : unsigned_arr) return string;
    function toStr(val : signed_arr) return string;

end package numericstd_array_str_pkg;

package body numericstd_array_str_pkg is

  function fromStrToUnsignedArray(val : string) return unsigned_arr is
    variable retVal : unsigned_arr;
  begin
    assert(elemPerLine = getLstNumSeg(val, string'(" ")))
      report "wrong number of elements per line" severity warning;
    for i in 0 to elemPerLine - 1 loop
      retVal(i) := strToUnsigned(getLstSeg(val, i, string'(" ")), bitsPerElem);
    end loop;
    return retVal;
  end function fromStrToUnsignedArray;

  function fromStrToSignedArray(val : string) return signed_arr is
    variable retVal : signed_arr;
  begin
    assert(elemPerLine = getLstNumSeg(val, string'(" ")))
      report "wrong number of elements per line" severity warning;
    for i in 0 to elemPerLine - 1 loop
      retVal(i) := strToSigned(getLstSeg(val, i, string'(" ")), bitsPerElem);
    end loop;
    return retVal;
  end function fromStrToSignedArray;

-- ---------------------------------------------------------------------------
  function toStr(val : unsigned_arr; startAt : natural) return string is
  begin
    if startAt < val'length - 1 then
      return toStr(val(startAt)) & string'(" ") & toStr(val, startAt + 1);
    else
      return toStr(val(startAt));
    end if;
  end function toStr;

  function toStr(val : unsigned_arr) return string is
  begin
    return toStr(val, 0);
  end function toStr;


--   ------------------------------------------------------------------------------
  
  function toStr(val : signed_arr; startAt : natural) return string is
  begin
    if startAt < val'length - 1 then
      return toStr(val(startAt)) & string'(" ") & toStr(val, startAt + 1);
    else
      return toStr(val(startAt));
    end if;
  end function toStr;  

  function toStr(val : signed_arr) return string is
  begin
    return toStr(val, 0);
  end function toStr;
end package body numericstd_array_str_pkg;
