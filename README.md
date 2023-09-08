# scarlett-instrumentation
Building low-frequency instrumentation tools around the [Focusrite Scarlett 2i2 3rd Gen](https://focusrite.com/products/scarlett-2i2-3rd-gen) and similar interfaces. 

## Introduction
The lack of low-frequency spectrum analyzers, vector network analyzers etc. prompted me to make my own. And it's always great when you can operate at orders of magnitude lower cost than what such instruments regularly go for!

The Focusrite Scarlett 2i2 is a two-channel USB ADC + DAC designed to interface musical instruments. This project will primarily use it as a programmable line input and output device. 

Where the Scarlett 2i2 does not have the desired impedance, current or voltage for a given measurement purpose, small PCB will act as amplifiers between the Scarlett 2i2 and a Device Under Test (DUT). 

Both code and PCBs are under GPL-3.0. If you contribute PCBs, include as the very least a PDF of the Schematic, Gerber files of the board and a human readable BOM. Please also include schematic and layout binaries.

## Code development and support
Initial code is written in [GNU Octave](https://octave.org) 8.3.0 running on Windows 11. One known bug is that the ADC input is truncated to 16 bits of resolution, not the desired 24. Initial efforts focus on identifying the audio device and analog volume settings for reading and writing audio data.

### Windows setup
- Sound Settings -> Output -> Scarlett 2i2 USB -> 2 channels, 24 bit, 96000 kHz, Volume = 100
- Sound Settings -> Input -> Scarlett 2i2 USB -> 2 channels, 24 bit, 96000 Hz, Volume = 54 (= 0dB in Windows)

Feel free to add notes about other verified software combinations.

## Projects

### Low-frequency impedance meter
What is the impedance at a point of load? This project will inject a current (large voltage through large resistor) into the load and measure the resulting voltage. This will be swept or repeated at relevant frequencies. A long probe cable leads from the PCBA to the DUT. The impedance of the probe can be recorded and later subtracted by shorting it. Reference resistors on the interface PCB can be selected by jumpers to verify the measurement principle before short at the tip of the probe is removed and replaced by the DUT. 

Status: Under development, PCB ordered

PCB and schematic: "supply_AC_meas_C" to be released after initial test

Code: TBD

## Code
Please use the following coding style:
- One file for each function
- Each file is named as its function
- All function and file names are prefixed "sc_"
- All files start with GPL 3 header as Matlab commet
- Preferable indentation is two space characters
- Do *not* use Tab as indentation character since that will confuse Octave during copy-paste
- Minimize inline if and for, rather use new line, indent and "end" on separate line
- UTF-8 encoding seems to work OK

## Functions

### Identify the ADC and DAC device
```
[input_id, output_id] = sc_identify_device(name);
```
input_id = returned id of input device for use with Octave audio subsystem

output_id = returned id of output device for use with Octave audio subsystem

name = "2i2" to search for Focusrite Scarlett 2i2 device

Status: Worked on Win10 / Octave 8.3.0, on Win11, returned output_id is off

Example:
```
>[input_id, output_id] = sc_identify_device("2i2")
input_id = 1
output_id = 8
```

### Play two sine waves
```
sc_sine_generator(output_id, fs, resolution, freq_L, amplitude_L, freq_R, amplitude_R, duration)
```
output_id = id of output device for use with Octave audio subsystem

fs = sample rate in Hz, typically 96000. You may need to set this manually in your OS as well

resolution = resolutin in bits. Use 24. ou may need to set this manually in your OS as well

freq_L = the frequency in Hz to be used in the Left output channel, [0, fs/2)

amplitude_L = the normalized amplitude for the Left channel, [0, 1)

freq_R = the frequency in Hz to be used in the Right output channel, [0, fs/2)

amplitude_R = the normalized amplitude for the Right channel, [0, 1)

duration = the duration of the tone in seconds

Status: Works on Win11 / Octave 8.3.0 with manually set output_id

Example:
```
sc_sine_generator(6, fs, resolution, 1000, 0.5, 500, 0.8, 5)
```

 

