Weekly Report 6.7-6.13

  Designed an asynchronous FIFO and a syncchronous FIFO, for verilog practicing and part of one of my final project. Read several papers, which are mainly about Globally Asynchronous Locally Synchronous System.
  Next week is about to prepare for my final examinations and projects.
  The verilog code I wrote has been uploaded.
  
------------------------------------------
Weekly Report 5.10-5.25
  
  I designed a video realtime display system using OV5640 with SCCB interface, the main codes are already finished, now configuring the camera configuration registers(the display effect is not good, the picture size, fps and color remain to be optimized). 
  The codes and schemetic are uploaded. 
  
------------------------------------------
Weekly Report 4.26-5.9

  Finished the whole IIC EEPROM project, including RTL coding and testing, the verilog files have beed updated.
  Now doing some reaerch on using OV7670. Finished the SCCB control module writing, now working on configuring registers of OV7670.
  Read several papers about Global Asynchronous and Local Synchronous, it's part of a school course project.
  
------------------------------------------
Weekly Report 4.19-4.25

  This week I finished writing the verilog module EEPROM using IIC, and finished some basic test on behavior simulation(write data to certain space area and read it). Now I'm writing a more complete testbench to test it.
  The code files are uploaded already.
  
------------------------------------------
Weekly Report 4.12-4.18

  This week I did some research on IIC BUS and now I'm trying to write a IIC EEPROM Verilog module for practice. This module has three parts: IIC control logic, EEPROM and a testbench which acts as CPU.
  
------------------------------------------
Weekliy Report 4.5-4.11

  I have been working on Linux device driver writing. An AXI device is created and used in the hardware design, a device driver is needed for this AXI device. I wrote a driver and packaged it as a .ko file in order to install the driver into the Linux kernel.However some "Invalid format module" error shows. I think it's because the kernel edition that the .ko file uses is different from the Linux kernel edition. Haven't find the solution yet.
  
------------------------------------------
Weekly Report 3.29-4.4

1.Did some research about writing device driver in embedded Linux. Inserting custom IP into hardware design and running it on Linux in FPGA requires a device driver for it and it looks pretty difficult. Now I'm trying to make a simple AXI-lite device driver. I'm not sure whether I can make it.

2.Script language Perl learning, Verilog HDL learning.

------------------------------------------
Weekly Report 3.21-3.28

1.Verilog HDL learning . Now writing a Parallel_to_Serial module to practice HDL coding. Next step is to write a IIC module to continue the practice. 

2.Embedded Linux system built on FPGA documentation writing, to record the workflow, and ensure the workflow is suitable to most hardware designs.


Plan for next week:
1.Continue the HDL learning.
2.Going to learning some script language.
3.Paper reading.
