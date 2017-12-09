# FPGA Driven Videogame
By Antoine Viscardi and Zack Lefrançois.
This project was completed as part of the GEF495 (Architecture des Systèmes Numériques) course at the Royal Military College of Canada.

## Introduction
The goal of this term long project was to learn and practice the complete digital design process by implementing a simple game in hardware logic using VHDL and running on the Basys 2 FPGA development board. The game had to drive a VGA interface at a 640p x 480p resolution and implement moving a colision logic.

## Preliminary Designs and Theory
Before jumping into the design and implementation of the video game, we first developed two simple digital circuits to familiarize ourselves with the VHDL language and the theory behind the VGA interface. 

### Driving the VGA Interface
Our first design was a simple circuit described in VHDL that ultimatly drived the VGA connector. We could then, with simple logic, displa different colors and shapes on the monitor. This VGA driver we developped was later reused in our final implementation of the video game.
