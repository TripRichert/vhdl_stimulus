# vhdl_stimulus
Unit testing library for file based generation of test stimulus for exciting units under test, logging the output, and verifying the result.

This library relies on generic types in generic packages. It was tested using the GHDL v0.35. It can be used with or without VUnit (tested with 3.6.2).

Some commonly used VHDL simulation tools do not support generic packages and will not work with this library.