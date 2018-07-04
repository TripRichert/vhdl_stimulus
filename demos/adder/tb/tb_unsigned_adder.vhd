library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;

entity tb_unsigned_adder is
  generic (
    runner_cfg : string := runner_cfg_default;
    input_filename : string := "testdata/test0.dat";
    output_filename : string := "testdata/sum0.dat"
    );
end entity;

architecture tb of tb_unsigned_adder is
  component test_unsigned_adder is
    generic (
      input_filename : string := "testdata/data0.dat";
      output_filename : string := "testdata/sum0.dat"
    );
    port (
      done : out std_ulogic
      );
  end component test_unsigned_adder;

  signal done : std_ulogic;
begin
  uut: test_unsigned_adder
    generic map (
      input_filename => input_filename,
      output_filename => output_filename
      )
    port map(
      done => done
      );
  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);
    wait until done = '1';
    report "We got here after all";
    test_runner_cleanup(runner); -- Simulation ends here
    wait;
  end process;
end architecture;
