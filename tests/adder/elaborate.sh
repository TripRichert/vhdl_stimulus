#!/bin/bash

/home/bin/bin/ghdl -a --std=08 ../../hdl/textio_ext.vhd
/home/bin/bin/ghdl -a --std=08 ../../hdl/from_str_pkg.vhd
/home/bin/bin/ghdl -a --std=08 ../../hdl/str_lst_pkg.vhd
/home/bin/bin/ghdl -a --std=08 ../../hdl/stimulus_pkg.vhd
/home/bin/bin/ghdl -a --std=08 tb/test_unsigned_adder.vhd
/home/bin/bin/ghdl -e --std=08 test_unsigned_adder
