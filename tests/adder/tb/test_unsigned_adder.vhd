library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_unsigned_adder is
  generic ( filename : string := "testname.txt");
end entity test_unsigned_adder;

architecture behavioral of test_unsigned_adder is
  signal clk : std_ulogic;
  signal tvalid : std_ulogic;
  signal tready : std_ulogic;
  signal tlast  : std_ulogic;
  signal done   : std_ulogic := '0';

  component axistream_stim_unsigned is
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
  end component axistream_stim_unsigned;

  constant clk_period : time := 10 ns;
begin

  assu_0 : axistream_stim_unsigned
    generic map (filename => filename)
    port map (
      clk => clk,
      tvalid => tvalid,
      tready => tready,
      tlast  => tlast,
      done => done
      );
  
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
