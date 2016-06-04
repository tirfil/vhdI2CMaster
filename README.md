
# I2C Master finite state machine

Notes:
------
Vhdl code would be simplified.

Need to solve bug:
* Master should'nt acknowledge last byte received ( read operation ).

System Interface :
----------------

| Pins   | Io | Notes |
| -------- | ---- | --------------------- |
| MCLK | clock | Master clock |
| nRST | input | Asynchronious reset active low | 
| SRST | input | Synchronious reset active high ( for debug purpose ) |
| TIC | input | i2c rate pulse ( bit rate x3 ) |
| DIN[7:0] | input | Input data bus |
| RD  | input | Read command operation |
| WE  | input | Write command operation |
| QUEUED | output | Write command is accepted, next operation ( write or read ) could be introduced | 
| NACK | output | Remote slave interface doesn't acknowledge write operation |
| DOUT[7:0] | output | Output data bus |
| DATA_VALID | output | Output data is valid on bus |
| STATUS[2:0] | output | finite state machine status ( for debug purpose ) |


![waveform](https://github.com/tirfil/vhdI2CMaster/blob/master/image/i2cmaster.png)

