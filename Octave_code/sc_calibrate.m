% Calibrate output voltage
% Usage: defaults = sc_calibrate(defaults);
% Calibrate sequence: left output, left input, right input. Measure right gain factor.
% Calibration is done at 200Hz, presumably above hi-pass cross-over frequencies, low enough for RMS multimeters
% Full-scale shall be defined as:
% 90% DAC utilization
% 2.0000 VRMS differential output = 5.6569 VPP differential output

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

function right_gain = sc_calibrate(defaults)
  printf ("\n");
  printf ("Measure the AC voltage between left output Tip and Ring connectors.\n");
  printf ("Turn MONITOR knob until you reach one of the following:\n");
  printf ("  2.0000 VRMS\n");
  printf ("  5.6569 VPP\n");
  printf ("For less precise single-ended calibration measure between Tip and Sleeve \n");
  printf ("and adjust for half of these voltages\n\n");  
  
  % Play a 200Hz tone for 10 seconds
  sc_sine_generator(output_id, fs, 24, 200, 0.9, 200, 0, 20); % Play only in left
  
    
  %% *** Wait for keypress
  
  printf ("\n");
  printf ("Plug left output into left input.\n");
  printf ("Turn left GAIN knob until result prints as 1.000\n");
  


  extra_pause = 0.4; % How many more seconds than "duration" should execution halt during playback?
  record_duration = 1;

  clear recorder;
  recorder = audioplayer(y, fs, 24, input_id);

  record(recorder, record_duration); pause(record_duration + extra_pause);
  in_data = getaudiodata(recorder);


endfunction


