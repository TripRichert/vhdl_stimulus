library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.str_lst_pkg.all;
use work.from_str_pkg.all;
use work.to_str_pkg.all;

entity test_stall is
  generic (
    input_filename : string := "testdata/test1.dat";
    ctrlInput_filename : string := "testdata/noctrl.dat";
    ctrlOutput_filename : string := "testdata/noctrl.dat";
    output_filename : string := "testdata/sum1.result";
    timeout         : time   := 1 us
    );
  port (
    done : out std_ulogic
    );

  constant elemPerLine : natural := 2;
  constant bitsPerElem : natural := 8;

  --defined unsigned array and functions from and to strings for it
  package numeric_string is
      new work.numericstd_array_pkg generic map(elemPerLine, bitsPerElem);
  use numeric_string.all;

  --! wrapper unfortunately needed to get around ghdl bug
  function fromStr(val : string) return unsigned_arr is
  begin
    return fromStrToUnsignedArray(val);
  end function fromStr;
                                      
  package stimulus_pkg_Unsigned is
      new work.stimulus_pkg generic map(unsigned_arr, fromStr);
  use stimulus_pkg_Unsigned.axiStreamStimulus;
      
  --! wrapper unfortunately needed to get around ghdl bug
  function toStrCpy(val : unsigned_arr) return string is
  begin
    return toStr(val);
  end function toStrCpy;

  package log_pkg_Unsigned is
      new work.log_pkg generic map(unsigned_arr, toStrCpy);
  use log_pkg_Unsigned.axiStreamLog;

end entity test_stall;

architecture behavioral of test_stall is

  signal clk : std_ulogic;
  signal tvalid : std_ulogic;
  signal tready : std_ulogic;
  signal tdata : unsigned_arr;
  signal tdata_flattened : std_ulogic_vector(elemPerLine * bitsPerElem - 1 downto 0);
  signal tlast  : std_ulogic;

  signal ctrl_tvalid : std_ulogic;
  signal ctrl_tready : std_ulogic;
  signal ctrl_tlast  : std_ulogic;

  signal stall_tvalid : std_ulogic;
  signal stall_tready : std_ulogic;
  signal stall_tlast  : std_ulogic;

  
  signal log_tvalid : std_ulogic;
  signal log_tready : std_ulogic;
  signal log_tdata_flattened : std_ulogic_vector(elemPerLine * bitsPerElem - 1 downto 0);
  signal log_tdata  : unsigned_arr;
  signal log_tlast  : std_ulogic;


  signal inputDone   : std_ulogic := '0';
  signal closeOutput : std_ulogic := '0';

  constant clk_period : time := 10 ns;

  signal tlast_cnt : natural := 0;
  signal logTlast_cnt : natural := 0;

  signal timedout : boolean := false;

begin


  process
  begin
    inputDone <= '0';

    axiStreamStimulus(
      filename => input_filename,
      clk => clk,
      edge => '1',
      tvalid => tvalid,
      tready => tready,
      tdata => tdata,
      tlast => tlast,
      done => inputDone
      );
  end process;

    inputCtrl: entity work.axistream_flowctrl
    generic map (
      edge => '1',
      ctrl_filename => ctrlInput_filename
      )
    port map (
      clk => clk,
      src_tvalid => tvalid,
      src_tready => tready,
      src_tlast => tlast,
      dest_tvalid => ctrl_tvalid,
      dest_tready => ctrl_tready,
      dest_tlast  => ctrl_tlast,
      closeFile   => closeOutput
      );

  tdata_flattened <= flatten(tdata);
  uut: entity work.axistream_stall
  generic map (
    bitWidth => elemPerLine * bitsPerElem
    )
  port map (
    clk         => clk,
    src_tvalid  => ctrl_tvalid,
    src_tready  => ctrl_tready,
    src_tdata => tdata_flattened,
    src_tlast   => ctrl_tlast,
    dest_tvalid => stall_tvalid,
    dest_tready => stall_tready,
    dest_tdata  => log_tdata_flattened,
    dest_tlast  => stall_tlast
    );

  outputCtrl: entity work.axistream_flowctrl
    generic map (
      edge => '1',
      ctrl_filename => ctrlOutput_filename
      )
    port map (
      clk => clk,
      src_tvalid => stall_tvalid,
      src_tready => stall_tready,
      src_tlast => stall_tlast,
      dest_tvalid => log_tvalid,
      dest_tready => log_tready,
      dest_tlast  => log_tlast,
      closeFile   => closeOutput
      );

  log_tdata <= unflatten_unsignedArr(log_tdata_flattened);
  process
  begin
    axiStreamLog(
      filename => output_filename,
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
    if timedout then
      wait;
    end if;
  end process;

  --keep track of tlasts to make sure all data is processed.
  --this allows latency in the unit under test without closing log file
  --prematurely
  process(clk)
  begin
    if rising_Edge(clk) then
      if tlast = '1' and tvalid = '1' and tready = '1' then
        tlast_cnt <= tlast_cnt + 1;
      end if;
      if log_tlast = '1' and log_tvalid = '1' and log_tready = '1' then
        logTlast_cnt <= logTlast_cnt + 1;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      assert logTlast_cnt <= tlast_cnt
        report "more output tlasts than input tlasts" severity failure;

      --wait until received and written all tlasts before closing logfile
      if inputDone = '1' and logTlast_cnt = tlast_cnt then
        closeOutput <= '1';
      end if;
    end if;
  end process;

  --if running ghdl without vunit, need to stop simulation. Either
  process
  begin
    wait for timeout;
    timedout <= true;
    wait;
  end process;

  done <= closeOutput;
  
end architecture behavioral;
