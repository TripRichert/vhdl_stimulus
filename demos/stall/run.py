#!/usr/bin/env python
from os.path import join, dirname
from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files(join(dirname(__file__), '..', '..', 'hdl', '*.vhd'))
lib.add_source_files(join(dirname(__file__), 'hdl', '*.vhd'))
lib.add_source_files(join(dirname(__file__), 'tb', '*.vhd'))

tb = lib.entity("tb_stall")
testdata_dir = join(dirname(__file__), 'testdata')
test0Generics = dict(input_filename=join(testdata_dir, 'test0.dat'), output_filename=join(testdata_dir, 'test0.result'));
test1Generics = dict(input_filename=join(testdata_dir, 'test1.dat'), output_filename=join(testdata_dir, 'test1.result'));
tb.add_config(name="test0", generics=test0Generics);
tb.add_config(name="test1", generics=test1Generics);
# Run vunit function
vu.main()
