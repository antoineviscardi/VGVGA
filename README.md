# FPGA Driven Videogame
By Antoine Viscardi and Zack Lefrançois.
This project was completed as part of the GEF495 (Architecture des Systèmes Numériques) course at the Royal Military College of Canada.

## Introduction
The goal of this term long project was to learn and practice the complete digital design process by implementing a simple game in hardware logic using VHDL and running on the Basys 2 FPGA development board. The game had to drive a VGA interface at a 640p x 480p resolution and implement moving a colision logic.

## Preliminary Designs and Theory
Before jumping into the design and implementation of the video game, we first developed two simple digital circuits to familiarize ourselves with the VHDL language and the theory behind the VGA interface. 

### Driving the VGA Interface
Our first design was a simple circuit described in VHDL that ultimatly drived the VGA connector. We could then, with simple logic, displa different colors and shapes on the monitor. This VGA driver we developped was later reused in our final implementation of the video game.

#### Clock Signal
In order to drive the VGA for our required resolution of 640p x 480p, we need a clock signal oscillating at of 25MHz. The Basys 2 board has a clock of 50MHz and offers jumper pins to generate a clock of 25Mhz but we had no access to the soldering material required to do so. We therefore had to implement a simple circuit to divide our clock frequency by a factor of two. The simple [`clk_divider`](./src/clk_divider.vhd) module serves this purpose.

#### Synchronization and color signals
The figure bellow shows the different timings to respect to drive the VGA. We need two signals, `HSYNC` and `VSYNC`, that are responsible to synchronize the horizontal and the vertical sweeping of the monitor, and 8 other signals to drive the RGB color pins (3 pins for red, 3 pins for green and 2 pins for blue).

The `HSYNC` and `VSYNC` signals were generated using two counts incremented at every clock cycle. Every timing such as the sync pulse or the front porch were then assigned a certain amount of clock ticks. From those constants conditions for what values the syncrhonizing signals should have at any moment of the sweep were implemented. It is the [vga_driver](./src/vga_driver.vhd) module that is responsible for the generation of the VGA signals.

<img src="./figures/VGA_timing_diagram.jpg" height="500">
