library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;

entity tb_stall is
  generic (
    runner_cfg : string := runner_cfg_default;
    input_filename : string := "testdata/test0.dat";
    ctrlInput_filename : string := "testdata/noctrl.dat";
    ctrlOutput_filename : string := "testdata/noctrl.dat";
    output_filename : string := "testdata/test0.result"
    );
end entity;

architecture tb of tb_stall is

  signal done : std_ulogic;
begin

  uut: entity work.test_stall
    generic map (
      input_filename => input_filename,
      ctrlInput_filename => ctrlInput_filename,
      ctrlOutput_filename => ctrlOutput_filename,
      output_filename => output_filename
      )
    port map(
      done => done
      );
  
  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);
    wait until done = '1';
    test_runner_cleanup(runner); -- Simulation ends here
    wait;
  end process;
  
end architecture;
