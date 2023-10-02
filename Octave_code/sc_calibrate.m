% Calibrate output voltage
% Usage: defaults = sc_calibrate(defaults);
% Calibrate sequence: left output, left input, right input. Measure right gain factor.
% Calibration is done at 200Hz, presumably above hi-pass cross-over frequencies, low enough for RMS multimeters
% Utilization of converters and analog IO is set up in sc_init()

% Copyright (C) 2023 Børge Strand-Bergesen
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function defaults = sc_calibrate(defaults)
  printf ("\nPLEASE FOLLOW INSTRUCTIONS\n\n");
  printf ("Remove all connections from Focusrite instrument.\n");
  printf ("Insert a 6.3mm TRS cable in the rear LEFT LINE OUTPUT plug.\n");
  printf ("Measure the voltage between Tip and Ring on the other end of the cable.\n");
  printf ("Turn MONITOR knob until you reach one of the following:\n");
  printf ("%1.4f VRMS or %1.4f VPP\n", defaults.dac_vrms, defaults.dac_vrms*2*sqrt(2));
  printf ("For less precise single-ended calibration measure between Tip and Sleeve \n");
  printf ("and adjust for half of these voltages\n\n");
  printf ("Press any key when done.\n");
  
  % Play a 200Hz tone until button is pressed
  
  duration = 60; % 300ms gaps may occur between each period of <duration> seconds
  freq_calib = 200; % Calibration frequency
  n = duration * defaults.fs; % The number of samples in each tone
  output_active = defaults.dac_util * sin([0:n-1] * freq_calib / defaults.fs * 2 * pi);
  output_mute = output_active * 0; % Mute right channel during calibration of left
  y = ([output_active' output_mute']); % Consumes a lot of memory. Rather that than gaps
  player = audioplayer(y, defaults.fs, defaults.resolution, defaults.output_id);
  recorder = audiorecorder(defaults.fs, defaults.resolution, 2, defaults.input_id);

  run = 1;
  while (run)
    play (player);

    while (isplaying(player))
      if (length(kbhit(1)) != 0)
        run = 0;
        stop (player);
      endif
	  
	  pause(0.3);
	  printf(".");
	  fflush(stdout);
    endwhile
  endwhile

  printf ("\n");
  printf ("Connect the TRS cable from rear LEFT LINE OUTPUT to front 1 INPUT\n\n");
  printf ("Press any key when done.\n");

  run = 1;
  while (run)
    if (length(kbhit(1)) != 0)
      run = 0;
    endif

    pause(0.3);
	printf(".");
	fflush(stdout);
  endwhile

  printf ("\n");
  printf ("Adjust the front left GAIN knob to get this printout close to 100.0%%\n\n");
  printf ("Press any key when done.\n");
  
  run = 1;
  while (run)
    play (player);

    while (isplaying(player))
      if (length(kbhit(1)) != 0)
        run = 0;
        stop (player);
      endif

      record (recorder, 0.5); % Record 0.5s
	  while (isrecording(recorder))
	    pause(0.1);
	  endwhile
	  data = getaudiodata(recorder, "double") / defaults.adc_util;
	  maxdata = max(data(:,1)) * 100; % Normalized left ADC values in %
	  
	  printf("%3.1f\n", maxdata);
	  fflush(stdout);
    endwhile
  endwhile
  
  printf ("\n");
  printf ("Connect the TRS cable from rear LEFT LINE OUTPUT to front 2 INPUT\n\n");
  printf ("Press any key when done.\n");

  run = 1;
  while (run)
    if (length(kbhit(1)) != 0)
      run = 0;
    endif
  endwhile

  printf ("\n");
  printf ("Adjust the front right GAIN knob to get this printout close to 100.0%%\n\n");
  printf ("Press any key when done.\n");
  
  run = 1;
  while (run)
    play (player);

    while (isplaying(player))
      if (length(kbhit(1)) != 0)
        run = 0;
        stop (player);
      endif

      record (recorder, 0.5); % Record 0.5s
	  while (isrecording(recorder))
	    pause(0.1);
	  endwhile
	  data = getaudiodata(recorder, "double") / defaults.adc_util;
	  maxdata = max(data(:,2)) * 100; % Normalized right ADC values in %
	  
	  printf("%3.1f\n", maxdata);
	  fflush(stdout);
    endwhile
  endwhile
 
  printf ("\n");
  printf ("Connect the TRS cable from rear RIGHT LINE OUTPUT to front 2 INPUT\n\n");
  printf ("Press any key when done.\n");

  run = 1;
  while (run)
    if (length(kbhit(1)) != 0)
      run = 0;
    endif
  endwhile

  % Play on right output. Mute left output, record right gain
  clear player;
  y = ([output_mute' output_active']); % Consumes a lot of memory. Rather that than gaps
  player = audioplayer(y, defaults.fs, defaults.resolution, defaults.output_id);

  play (player);

  for (n=1:8) % Record some dry runs at first
    record (recorder, 0.5); % Record 0.5s
    while (isrecording(recorder))
      pause(0.1);
	endwhile
	data = getaudiodata(recorder, "double") / defaults.adc_util;
  endfor

  defaults.gain_R = max(data(:,2));

  stop (player);

  clear player;
  clear recorder;   

endfunction



