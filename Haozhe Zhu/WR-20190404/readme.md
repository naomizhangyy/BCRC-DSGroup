# Weekly Report (Apr 4, 2019)

## Continue working on ARM SoC.

 
     ---------
     |  ARM  |
     |  CM3  |
     ---------
        \ / ICode-DCode-Mux
         |
_________|______________________________________________AHB1
     |                     |                 |
 ----------                |AHB2AHB bridge   |AHB2APB bridge
 |  RAMs  |                |                 |
 ----------                |                 |---Timer1
                           |                 |
___________________________|_____AHB2        |---Timer2
    |                                        |  
    |                                        |---UART/I2C/SPI ...
    Off-chip RAMs


