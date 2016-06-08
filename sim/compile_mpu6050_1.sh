#!/bin/bash

set FLAG=-v --syn-binding --workdir=work  --work=work --ieee=synopsys --std=93c -fexplicit
#
ghdl -a $FLAG  ../mpu6050/mpu6050.vhd
ghdl -a $FLAG  ../vhdl/i2cmaster.vhd
#ghdl -a $FLAG ../test/tb_mpu6050_1.vhd
#ghdl -e $FLAG tb_mpu6050_1
#ghdl -r $FLAG tb_mpu6050_1 --vcd=mpu.vcd
