
# I2C Master finite state machine


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
| QUEUED | output | Current command is accepted, next operation ( write or read ) could be introduced | 
| NACK | output | Remote slave interface doesn't acknowledge write operation |
| DOUT[7:0] | output | Output data bus |
| DATA_VALID | output | Output data is valid on bus |
| STOP | output | Detect stop condition |
| STATUS[2:0] | output | Finite State Machine status ( for debug purpose ) |

Demo with MPU6050 : detect object orientation

X axis:

![xaxis](https://github.com/tirfil/vhdI2CMaster/blob/master/image/xaxis.JPG)

Y axis:

![yaxis](https://github.com/tirfil/vhdI2CMaster/blob/master/image/yaxis.JPG)

Z axis:

![zaxis](https://github.com/tirfil/vhdI2CMaster/blob/master/image/zaxis.JPG)

