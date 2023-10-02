# scarlett-instrumentation
Building low-frequency instrumentation tools around the [Focusrite Scarlett 2i2 3rd Gen](https://focusrite.com/products/scarlett-2i2-3rd-gen) and similar interfaces. 

## Introduction
The Focusrite Scarlett 2i2 is a two-channel USB ADC + DAC designed to interface musical instruments. This project will use it as a programmable input and output device and build custom interface boards for it.

The lack of low-frequency spectrum analyzers, vector network analyzers etc. prompted me to make my own. And it's always great when you can operate at orders of magnitude lower cost than what such instruments regularly go for!

Where the Scarlett 2i2 does not have the desired impedance, current or voltage for a given measurement purpose, small PCB will act as amplifiers between the Scarlett 2i2 and a Device Under Test (DUT). 

Both code and PCBs are under GPL-3.0. If you contribute PCBs, include as the very least a PDF of the Schematic, Gerber files of the board and a human readable BOM. Please also include schematic and layout binaries.

## Code development and support
Initial code is written in [GNU Octave](https://octave.org) 8.3.0 running on Windows 11. It is already up and running! 

### Known bugs:
- Win10 / Octave 8.3.0: ADC input is truncated to 16 bits of resolution, not the desired 24. Not yet tested on Win11
- Device identification worked on Win10 / Octave 8.3.0. It is a bit off on Win11 and needs manual override for now

### Windows setup
- Sound Settings -> Output -> Scarlett 2i2 USB -> 2 channels, 24 bit, 96000 kHz, Volume = 100
- Sound Settings -> Input -> Scarlett 2i2 USB -> 2 channels, 24 bit, 96000 Hz, Volume = 54 (= 0dB in Windows)

### Other OS / instrument / version combinations
Feel free to add notes about other verified software combinations

## Projects

### Low-frequency impedance meter
What is the impedance at a point of load? This project will inject a current (large voltage through large resistor) into the load and measure the resulting voltage. This will be swept or repeated at relevant frequencies. A long probe cable leads from the PCBA to the DUT. The impedance of the probe can be recorded and later subtracted by shorting it. Reference resistors on the interface PCB can be selected by jumpers to verify the measurement principle before short at the tip of the probe is removed and replaced by the DUT. 

Status: Under development, PCB ordered

PCB and schematic: "supply_AC_meas_C" to be released after initial test

Code: TBD

## Conventions
### Signal names in code and on PCBs:
- Signals are named Left and Right or 1 and 2. Left === 1 and Right === 2. We don't count from 0.
- Corresponding variables should be postfixed "_L" or "_1" and "_R or "_2", respectively
- Do not use postfixes "_L", "_1", "_R" and "_2" for other purposes
- Do not use prefixes as signal and channel indicators

### Code style
This project uses the programming language GNU Octave. Please use the following coding style:
- One file for each function
- Each file is named as its function
- All function and file names are prefixed "sc_"
- All files start with GPL 3 header as Matlab commet
- Preferable indentation is two space characters
- Do *not* use Tab as indentation character since that will confuse Octave during copy-paste
- Minimize inline *if* and *for*, rather use new line, indent and "end" on separate line
- UTF-8 encoding seems to work OK

## Functions

### Initiate
```
defaults = sc_init(fs, resolution, dac_util, adc_util);
```
defaults = initiates global variable

fs = sample rate, typically 96000. You may have to set this in the OS as well

resolution = bith depth in ADC and DAC, typically 24. May not always perform at 24 bits in Win11

dac_util = DAC utilization. Must be less than 1. Suggested level = 0.9

adc_util = ADC utilization. Likely 0.5 triggers transition from green to orange light. Suggested: 0.45

Example:
```
sc_defaults = sc_init(96000, 24, 0.9, 0.45);
```

### Identify the ADC and DAC device
Typically only called by sc_init()
```
[input_id, output_id] = sc_identify_device(name);
```
input_id = returned id of input device for use with Octave audio subsystem

output_id = returned id of output device for use with Octave audio subsystem

name = "2i2" to search for Focusrite Scarlett 2i2 device

Status: Worked on Win10 / Octave 8.3.0, on Win11, returned output_id was off in one test

Example:
```
>[input_id, output_id] = sc_identify_device("2i2")
input_id = 1
output_id = 8
```

### Play two sine waves without calibration
Amplitude is relative to DAC full-scale, not to calibrated analog levels.
```
sc_sine_generator(defaults, freq_L, amplitude_L, freq_R, amplitude_R, duration)
```
defaults = global configuration variable

freq_L = the frequency in Hz to be used in the Left output channel, [0, fs/2)

amplitude_L = the normalized amplitude for the Left channel, [0, 1)

freq_R = the frequency in Hz to be used in the Right output channel, [0, fs/2)

amplitude_R = the normalized amplitude for the Right channel, [0, 1)

duration = the duration of the tone in seconds

Status: Works on Win11 / Octave 8.3.0 with manually set output_id

Example:
```
sc_sine_generator(sc_defaults, 1000, 0.5, 500, 0.8, 5);
```

 

