--! @file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

package textio_ext is
  
  --! reads out of l into value until end of l or character in delim
  procedure read(l : inout Line; value : inout Line; delim : in string);
  
end package textio_ext;

package body textio_ext is
  function isContained(c : character; str : string) return boolean is
  begin
    if str'left < str'right then
      for i in str'left to str'right loop
        if c = str(i) then
          return true;
        end if;
      end loop;
    else
      for i in str'left downto str'right loop
        if c = str(i) then
          return true;
        end if;
      end loop;
    end if;
    return false;
  end function isContained;

  function distance(l : integer; r : integer) return natural is
  begin
    if l > r then
      return l - r;
    else
      return r - l;
    end if;
  end function distance;

  
  procedure read(l : inout Line; value : inout Line;
                 delim : in string) is

    variable newLeft : integer;
    variable newRight : integer;

    variable found_d : boolean := false;
    variable incr : integer;
    variable index : integer;

    variable tmp   : line;
  begin
    if value /= null then
      deallocate(value);
    end if;
    if l'left < l'right then
      incr := 1;
    else
      incr := -1;
    end if;
    index := l'left;


    if l'length > 0 then
      while index /= l'right and isContained(l(index), delim) loop
        index := index + incr;
      end loop;
    end if;
    if l'length = 0 or (index = l'right and isContained(l(index), delim)) then
      deallocate(l);
      l := new string'("");
      value := new string'("");
    else
      newLeft := index;
      while index /= l'right and not isContained(l(index), delim) loop
        index := index + incr;
      end loop;
      if index = l'right and not isContained(l(index), delim) then
        if newLeft <= l'right then
          value := new string(1 to distance(newLeft,l'right) + 1);
          value.all := l(newLeft to l'right);
        else
          value := new string(newLeft downto l'right);
          value.all := l(newLeft downto l'right);
        end if;
        deallocate(l);
        l := new string'("");
      else
        if newLeft < l'right then
          value := new string(1 to distance(newLeft, index));
          value.all := l(newLeft to index - incr);
        else
          value := new string(newLeft downto index - incr);
          value.all := l(newLeft downto index - incr);
        end if;
        if index <= l'right then
          tmp := new string(1 to distance(index, l'right) + 1);
          tmp.all := l(index to l'right);
        else
          tmp := new string(index downto l'right);
          tmp.all := l(index downto l'right);
        end if;
        deallocate(l);
        l := tmp;
      end if;
    end if;
  end procedure read;

end package body textio_ext;
