library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.str_lst_pkg.all;
use work.from_str_pkg.all;
use work.to_str_pkg.all;
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

  function toStr(val : elemType) return string is
  begin
   return toStr(val(0) + val(1));
  end function toStr;
      
  package log_pkg_Unsigned is new work.log_pkg generic map(unsigned(bitsPerElem downto 0), toStr);
  use log_pkg_Unsigned.axiStreamLog;

end entity test_unsigned_adder;

architecture behavioral of test_unsigned_adder is

  component axistream_unsigned_adder is
  generic (
    bitWidth : natural := 8
    );
  port (
    clk         : in std_ulogic;
    src_tvalid  : in std_ulogic;
    src_tready  : out std_ulogic;
    src_tdata_a : in unsigned(bitWidth - 1 downto 0);
    src_tdata_b : in unsigned(bitWidth - 1 downto 0);
    src_tlast   : in std_ulogic;
    dest_tvalid : out std_ulogic;
    dest_tready : in  std_ulogic;
    dest_tdata  : out unsigned(bitWidth downto 0);
    dest_tlast  : out std_ulogic
    );
  end component axistream_unsigned_adder;

  signal clk : std_ulogic;
  signal tvalid : std_ulogic;
  signal tready : std_ulogic;
  signal tlast  : std_ulogic;

  signal log_tvalid : std_ulogic;
  signal log_tready : std_ulogic;
  signal log_tlast  : std_ulogic;
  signal log_tdata  : Unsigned(bitsPerElem downto 0);

  signal inputDone   : std_ulogic := '0';
  signal closeOutput : std_ulogic := '0';

  constant clk_period : time := 10 ns;
  signal tdata : elemType;

  signal done  : std_ulogic;

  signal tlast_cnt : natural := 0;
begin

  process(clk)
  begin
    if rising_edge(clk) then
      closeOutput <= inputDone and log_tlast and log_tvalid and log_tready;
    end if;
  end process;

  process
  begin
    inputDone <= '0';

    axiStreamStimulus(
      filename => filename,
      clk => clk,
      edge => '1',
      tvalid => tvalid,
      tready => tready,
      tdata => tdata,
      tlast => tlast,
      done => inputDone
      );
  end process;

  process(clk)
  begin
    if rising_Edge(clk) then
      if tlast = '1' and tvalid = '1' and tready = '1' then
        tlast_cnt <= tlast_cnt + 1;
      end if;
    end if;
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

  uut: axistream_unsigned_adder
  generic map (
    bitWidth => bitsPerElem
    )
  port map (
    clk         => clk,
    src_tvalid  => tvalid,
    src_tready  => tready,
    src_tdata_a => tdata(0),
    src_tdata_b => tdata(1),
    src_tlast   => tlast,
    dest_tvalid => log_tvalid,
    dest_tready => log_tready,
    dest_tdata  => log_tdata,
    dest_tlast  => log_tlast
    );

  process
  begin
    axiStreamLog(
      filename => string'("outputFile.txt"),
      clk => clk,
      edge => '1',
      tvalid => log_tvalid,
      tready => log_tready,
      tdata => log_tdata,
      tlast => log_tlast,
      close => closeOutput
      );
  end process;

  
  process
  begin
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    if closeOutput = '1' then
      wait;
    end if;
  end process;

  process
  begin
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait;
  end process;
  
end architecture behavioral;