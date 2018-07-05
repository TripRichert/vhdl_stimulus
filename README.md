# vhdl_stimulus
Unit testing library for file based generation of test stimulus for exciting units under test, logging the output, and verifying the result.

This library relies on generic types in generic packages. It was tested using the GHDL v0.35. It can be used with or without VUnit (tested with 3.6.2).

To run a demo testbench, if you have VUnit on your python path and have it set up with a vhdl simulator, run run.py.

If you just want to run the demo in ghdl without vunit, and ghdl is on your path, run obsolete_elaboration.sh to elaborate the design and the commented out last line of that shell script to run the simulation.

Some commonly used VHDL simulation tools do not support generic packages and will not work with this library.