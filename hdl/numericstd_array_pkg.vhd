library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.str_lst_pkg.all;
use work.from_str_pkg.all;
use work.to_str_pkg.all;

package numericstd_array_pkg is
    generic (
      constant elemPerLine : natural := 2;
      constant bitsPerElem : natural := 4
      );

    type unsigned_arr is array(elemPerLine - 1 downto 0)
      of unsigned(bitsPerElem - 1 downto 0);
    
    type signed_arr is array(elemPerLine - 1 downto 0)
      of signed(bitsPerElem - 1 downto 0);

    function fromStrToUnsignedArray(val : string) return unsigned_arr;
    function fromStrToSignedArray(val : string) return signed_arr;
    function toStr(val : unsigned_arr) return string;
    function toStr(val : signed_arr) return string;
    function flatten(val : unsigned_arr) return std_ulogic_vector;
    function flatten(val : signed_arr) return std_ulogic_vector;
    function unflatten_unsignedArr(val : std_ulogic_vector) return unsigned_arr;
    function unflatten_signedArr(val : std_ulogic_vector) return signed_arr;
end package numericstd_array_pkg;

package body numericstd_array_pkg is

  function fromStrToUnsignedArray(val : string) return unsigned_arr is
    variable retVal : unsigned_arr;
  begin
    assert(elemPerLine = getLstNumSeg(val, string'(" ")))
      report "wrong number of elements per line" severity warning;
    
    --each segment is one unsigned number. Read each into element
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

    --each segment is one signed number. Read each into element
    for i in 0 to elemPerLine - 1 loop
      retVal(i) := strToSigned(getLstSeg(val, i, string'(" ")), bitsPerElem);
    end loop;
    
    return retVal;
  end function fromStrToSignedArray;

------------------------------------------------------------------------------
  --! recursive function returning remaining elements as string
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


-----------------------------------------------------------------------------
  --! recursive function returning remaining elements as string
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

  -----------------------------------------------------------------------------
  function flatten(val : unsigned_arr) return std_ulogic_vector is
    variable retVal : std_ulogic_vector(elemPerLine * bitsPerElem - 1 downto 0);
  begin
    for i in 0 to elemPerLine - 1 loop
      retVal((i + 1) * bitsPerElem - 1 downto i * bitsPerElem) := std_ulogic_vector(val(i));
    end loop;
    return retVal;
  end function flatten;

  function flatten(val : signed_arr) return std_ulogic_vector is
    variable retVal : std_ulogic_vector(elemPerLine * bitsPerElem - 1 downto 0);
  begin
    for i in 0 to elemPerLine - 1 loop
      retVal((i + 1) * bitsPerElem - 1 downto i * bitsPerElem) := std_ulogic_vector(val(i));
    end loop;
    return retVal;
  end function flatten;

  function unflatten_unsignedArr(val : std_ulogic_vector) return unsigned_arr is
    variable retVal : unsigned_arr;
  begin
    assert val'length = elemPerLine*bitsPerElem report "vector wrong length" severity error;
    for i in 0 to elemPerLine - 1 loop
      retVal(i) := unsigned(val((i+1)*bitsPerElem - 1 downto i*bitsPerElem));
    end loop;
    return retVal;
  end function unflatten_unsignedArr;

  function unflatten_signedArr(val : std_ulogic_vector) return signed_arr is
    variable retVal : signed_arr;
  begin
    assert val'length = elemPerLine*bitsPerElem report "vector wrong length" severity error;
    for i in 0 to elemPerLine - 1 loop
      retVal(i) := signed(val((i+1)*bitsPerElem - 1 downto i*bitsPerElem));
    end loop;
    return retVal;
  end function unflatten_signedArr;

end package body numericstd_array_pkg;
