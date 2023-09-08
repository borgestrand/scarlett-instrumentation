# scarlett-instrumentation
Building low-frequency instrumentation tools around the [Focusrite Scarlett 2i2 3rd Gen](https://focusrite.com/products/scarlett-2i2-3rd-gen) and similar interfaces. 

## Introduction
The lack of low-frequency spectrum analyzers, vector network analyzers etc. prompted me to make my own. 

The Focusrite Scarlett 2i2 is a two-channel USB ADC + DAC designed to interface musical instruments. This project will primarily use it as a programmable line input and output device. 

Where the Scarlett 2i2 does not have the desired impedance, current or voltage for a given measurement purpose, small PCB will act as amplifiers between the Scarlett 2i2 and a Device Under Test (DUT). 

## Code development and support
Initial code is written in [GNU Octave](https://octave.org) 8.3.0 running on Windows 11. One known bug is that the ADC input is truncated to 16 bits of resolution, not the desired 24. Initial efforts focus on identifying the audio device and analog volume settings for reading and writing audio data.

### Windows setup
A


Feel free to add notes about other verified software combinations.

## Projects

### Low-frequency impedance meter
What is the impedance at a point of load? This project will inject a current (large voltage through large resistor) into the load and measure the resulting voltage. This will be swept or repeated at relevant frequencies. A long probe cable leads from the PCBA to the DUT. The impedance of the probe can be recorded and later subtracted by shorting it. Reference impedances on the PCBs can be selected by jumpers to verify the measurement principle before short at the tip of the probe is removed and replaced by the DUT. 

Status: Under development, PCB ordered

PCB and schematic: "supply_AC_meas_C" to be released after initial test

Code: TBD

## Shared code
This project uses two space characters for indentation. Do *not* use Tab as indentation character since that will confuse Octave during copy-paste.

Identifying the USB devices. Tested on Octave 8.3.0 on Windows 10
```
n_input = audiodevinfo(1)/2; % How many input devices are there
n_output = audiodevinfo(0)/2; % How many output devices are there

for n=0:n_input-1, audiodevinfo(1,n), end; % List the input devices
for n=n_input:n_input+n_output-1, audiodevinfo(0,n), end; % List the output devices

n_input = audiodevinfo(1)/2; % How many input devices are there
n_output = audiodevinfo(0)/2; % How many output devices are there
input_name = "2i2";
output_name = "2i2";

% Find the input device with "input_name"
n_input_name = -1; % Initially mark as error
for n=0:n_input-1
  p = audiodevinfo(1,n);
  if (length(strfind(p, input_name)) > 0)
	n_input_name = n;
  end
end

% Find the output device with "output_name"
n_output_name = -1; % Initially mark as error
for n=n_input:n_input+n_output-1
  p = audiodevinfo(0,n);
  if (length(strfind(p, output_name)) > 0)
	n_output_name = n;
  end
end
```


