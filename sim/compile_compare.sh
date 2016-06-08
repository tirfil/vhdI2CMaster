#!/bin/bash

set FLAG=-v --syn-binding --workdir=work  --work=work --ieee=synopsys --std=93c -fexplicit
#
ghdl -a $FLAG  ../mpu6050/compare.vhd
ghdl -a $FLAG ../test/tb_compare.vhd
ghdl -e $FLAG tb_compare
ghdl -r $FLAG tb_compare --vcd=comp.vcd
