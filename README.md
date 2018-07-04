# vhdl_stimulus
Unit testing library for file based generation of test stimulus for exciting units under test, logging the output, and verifying the result.

This library relies on generic types in generic packages. It was tested using the vunit 3.6.2 with the latest ghdl.

The library won't work with Xilinx XSim because Xilinx doesn't support generic packages or VUnit.