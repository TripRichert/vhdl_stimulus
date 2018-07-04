#!/bin/bash

#Obsolete. Used to test without VUnit

ghdl -a --std=08 ../../hdl/textio_ext.vhd
ghdl -a --std=08 ../../hdl/from_str_pkg.vhd
ghdl -a --std=08 ../../hdl/to_str_pkg.vhd
ghdl -a --std=08 ../../hdl/str_lst_pkg.vhd
ghdl -a --std=08 ../../hdl/stimulus_pkg.vhd
ghdl -a --std=08 ../../hdl/log_pkg.vhd
ghdl -a --std=08 ../../hdl/numericstd_array_str_pkg.vhd

ghdl -a --std=08 hdl/axistream_unsigned_adder.vhd

ghdl -a --std=08 tb/test_unsigned_adder.vhd
ghdl -e --std=08 test_unsigned_adder

#to run
#ghdl -r --std=08 test_unsigned_adder

