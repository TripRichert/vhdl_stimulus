library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.str_lst_pkg.all;
use work.from_str_pkg.all;

entity test_unsigned_adder is
  generic ( filename : string := "testname.txt");

  constant elemPerLine : natural := 2;
  constant bitsPerElem : natural := 4;

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

end entity test_unsigned_adder;

architecture behavioral of test_unsigned_adder is
  signal clk : std_ulogic;
  signal tvalid : std_ulogic;
  signal tready : std_ulogic;
  signal tlast  : std_ulogic;
  signal done   : std_ulogic := '0';

  constant clk_period : time := 10 ns;
  signal tdata : elemType;

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
      tdata => tdata,
      tlast => tlast,
      done => done
      );
  end process;

  process(clk)
  begin
    if rising_Edge(clk) then
      if tvalid = '1' and tready = '1' then
        report string'("0: ") & integer'image(to_integer(tdata(0)));
        report string'("1: ") & integer'image(to_integer(tdata(1)));
      end if;
    end if;
  end process;

  
  process
  begin
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    if done = '1' then
      wait;
    end if;
  end process;

  process
  begin
    tready <= '0';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    tready <= '1';
    wait;
  end process;
  
end architecture behavioral;
