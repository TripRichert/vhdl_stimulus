#!/bin/bash

#Obsolete. Used to test without VUnit

ghdl -a --std=08 ../../hdl/textio_ext.vhd
ghdl -a --std=08 ../../hdl/from_str_pkg.vhd
ghdl -a --std=08 ../../hdl/to_str_pkg.vhd
ghdl -a --std=08 ../../hdl/str_lst_pkg.vhd
ghdl -a --std=08 ../../hdl/stimulus_pkg.vhd
ghdl -a --std=08 ../../hdl/log_pkg.vhd
ghdl -a --std=08 ../../hdl/axistream_flowctrl.vhd
ghdl -a --std=08 ../../hdl/numericstd_array_pkg.vhd

ghdl -a --std=08 hdl/axistream_stall.vhd

ghdl -a --std=08 tb/test_stall.vhd
ghdl -e --std=08 test_stall

#to run
#ghdl -r --std=08 test_stall

