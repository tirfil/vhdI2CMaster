#!/bin/bash

set FLAG=-v --syn-binding --workdir=work  --work=work --ieee=synopsys --std=93c -fexplicit
#
ghdl -a $FLAG  ../vhdl/i2cmaster.vhd
ghdl -a $FLAG ../test/tb_i2cmaster.vhd
ghdl -e $FLAG tb_i2cmaster
ghdl -r $FLAG tb_i2cmaster --vcd=core.vcd
