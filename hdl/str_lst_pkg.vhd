library ieee;
use ieee.std_logic_1164.all;

--! string tokenizer package
package str_lst_pkg is
  
  --! returns number of substrings split by any delimator character in delim
  function getLstNumSeg(val : string; delim : string) return natural;

  --! returns the index'th substring (token) split by any character in delim
  function getLstSeg(val : string; index : natural; delim : string)
    return string;
  
end package str_lst_pkg;

package body str_lst_pkg is

  function isMatch(c : character; delim : string) return boolean is
  begin
    for i in delim'left to delim'right loop
      if c = delim(i) then
        return true;
      end if;
    end loop;
    return false;
  end function isMatch;
  
  function getLstNumSeg(val : string; delim : string) return natural is
    variable index : integer := val'left;
    variable incr  : integer;
    variable cnt   : natural := 0;
    
  begin
    if val'left < val'right then
      incr := 1;
    else
      incr := -1;
    end if;
    if val'length = 0 then
      return 0;
    end if;
    while index < val'right loop
      --skip delimators
      while index /= val'right and isMatch(val(index), delim) loop
        index := index + incr;
      end loop;
      if index = val'right then
        if isMatch(val(index), delim) then
          return cnt;
        else
          return cnt + 1;--one character after delimators
        end if;
      end if;
      cnt := cnt + 1;
      --skip nondelimators
      while index /= val'right and not isMatch(val(index), delim) loop
        index := index + incr;
      end loop;
    end loop;
    return cnt;
  end function getLstNumSeg;
  
  function getLstSeg(val : string; index : natural; delim : string)
    return string is
    
    variable incr  : integer;
    variable cnt   : natural := 0;
    variable v_index : integer := val'left;
    variable left : integer;
    variable right : integer;
  begin
    if val'left <= val'right then
      incr := 1;
    else
      incr := -1;
    end if;

    assert val'length > 0 report "string must have length to find substring"
      severity error;

    --skip characters before the index'th token
    while cnt < index loop
      assert v_index /= val'right report "substring index out of range"
        severity failure;
      
      while v_index /= val'right and isMatch(val(v_index), delim) loop
        v_index := v_index + incr;
      end loop;
      if not isMatch(val(v_index), delim) then
        cnt := cnt + 1;
      end if;
      while v_index /= val'right and not isMatch(val(v_index), delim) loop
        v_index := v_index + incr;
      end loop;
    end loop;
    --skip delimators to get to index'th token
    while v_index /= val'right and isMatch(val(v_index), delim) loop
      v_index := v_index + incr;
    end loop;

    --find end of index'th token
    left := v_index;
    while v_index /= val'right and not isMatch(val(v_index), delim) loop
      v_index := v_index + incr;
    end loop;
    if isMatch(val(v_index), delim) then
      v_index := v_index - incr;
    end if;
    right := v_index;

    if incr = 1 then
      return val(left to right);
    else
      return val(right downto left);
    end if;
  end function getLstSeg;
  
end package body str_lst_pkg;
