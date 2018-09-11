## _HARDWARE_
- Zybo Zynq-7000 ARM/FPGA SoC Trainer Board:  https://store.digilentinc.com/zybo-zynq-7000-arm-fpga-soc-trainer-board/ 

## _SOFTWARE_
- Vivado Design Suite: https://www.xilinx.com/products/design-tools/vivado.html

### 4-BIT UP/DOWN COUNTER
- Connect the board to a laptop/desktop. Open Vivado 2018.2. 
- Flow Navigator -> Program and Debug -> Open Hardware Manager -> Open target -> Auto Connect -> Program device
- Select a bitstream programming file and click on "Program" to download it to your harwdare device. 
- FPGA_COUNTER.bit: This .bit file is used to observe the output on the board's LEDs.
- FPGA_COUNTER_VGA.bit: This .bit file is used to observe the output on a computer screen.
- The video below shows the counter's operation. 

[![INTRO TO FPGAs: 4-BIT UP/DOWN COUNTER ON A ZYBO BOARD](http://img.youtube.com/vi/DrkU7wzI1gc/0.jpg)](https://www.youtube.com/watch?v=DrkU7wzI1gc "INTRO TO FPGAs: 4-BIT UP/DOWN COUNTER ON A ZYBO BOARD")

### FIBONACCI SERIES
- Connect the board to a laptop/desktop. Open Vivado 2018.2. 
- Flow Navigator -> Program and Debug -> Open Hardware Manager -> Open target -> Auto Connect -> Program device
- Select the bitstream programming file and click on "Program" to download it to your harwdare device.
- FIBONACCI_15.bit: Displays the first 15 fibonacci numbers on a computer screen, through a VGA connector.

[![INTRO TO FPGAs: FIBONACCI SERIES ON A ZYBO BOARD](http://img.youtube.com/vi/GFkzqQijoYw/0.jpg)](https://www.youtube.com/watch?v=GFkzqQijoYw "INTRO TO FPGAs: FIBONACCI SERIES ON A ZYBO BOARD")
