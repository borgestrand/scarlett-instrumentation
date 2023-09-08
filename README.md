# scarlett-instrumentation
Building low-frequency instrumentation tools around the Focusrite Scarlett 2i2 and similar interfaces. 

## Introduction
The lack of low-frequency spectrum analyzers, vector network analyzers etc. prompted me to make my own. 

The Focusrite Scarlett 2i2 is a two-channel USB ADC + DAC designed to interface musical instruments. This project will primarily use it as a programmable line input and output device. 

Where the Scarlett 2i2 does not have the desired impedance, current or voltage for a given measurement purpose, small PCB will act as amplifiers between the Scarlett 2i2 and a Device Under Test (DUT). 

## Code development and support
Initial code is written in Octave 8.3.0 running on Windows 11. One known bug is that the ADC input is truncated to 16 bits of resolution, not the desired 24. 

Feel free to add notes about other verified software combinations.

## Projects

### Low-frequency impedance meter
What is the impedance at a point of load? This project will inject a current (large voltage through large resistor) into the load and measure the resulting voltage. This will be swept or repeated at relevant frequencies. A long probe cable leads from the PCBA to the DUT. The impedance of the probe can be recorded and later subtracted by shorting it. Reference impedances on the PCBs can be selected by jumpers to verify the measurement principle before short at the tip of the probe is removed and replaced by the DUT. 

Status: Under development, PCB ordered

PCB and schematic: "supply_AC_meas_C" to be released after initial test

Code: TBD

### TBD project


