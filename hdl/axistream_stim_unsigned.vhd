--! @file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.str_lst_pkg.all;
use work.from_str_pkg.all;

entity axistream_stim_unsigned is
  generic (
    filename : string;
    elemPerLine : natural := 2;
    bitsPerElem : natural := 2
    );
  port (
    clk : in std_ulogic;
    tvalid : out std_ulogic;
    tready : in std_ulogic;
    tlast  : out std_ulogic;
    done   : out std_ulogic
    );

  type elemType is array(elemPerLine - 1 downto 0) of unsigned(bitsPerElem - 1 downto 0);

  function fromStr(val : string) return elemType is
    variable retVal : elemType;
  begin
    assert(elemPerLine = getLstNumSeg(val, string'(" ")))
      report "wrong number of elements per line" severity warning;
    for i in 0 to elemPerLine - 1 loop
      retVal(i) := strToUnsigned(getLstSeg(val, i, string'(" ")), bitsPerElem);
    end loop;
    return retVal;
  end function fromStr;
  
  package stimulus_pkg_Unsigned is new work.stimulus_pkg generic map(elemType, fromStr);
  use stimulus_pkg_Unsigned.axiStreamStimulus;

end entity axistream_stim_unsigned;

architecture behavioral of axistream_stim_unsigned is
  signal tdata_cpy : elemType;
begin

  process
  begin
    done <= '0';

    axiStreamStimulus(
      filename => filename,
      clk => clk,
      edge => '1',
      tvalid => tvalid,
      tready => tready,
      tdata => tdata_cpy,
      tlast => tlast,
      done => done
      );
  end process;

  process(clk)
  begin
    if rising_Edge(clk) then
      if tvalid = '1' and tready = '1' then
        report string'("0: ") & integer'image(to_integer(tdata_cpy(0)));
        report string'("1: ") & integer'image(to_integer(tdata_cpy(1)));
      end if;
    end if;
  end process;
  
end architecture behavioral;
