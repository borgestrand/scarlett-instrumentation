% Identify ADC and DAC device in Octave
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

function [input_id, output_id] = sc_identify_device(name)
  % input_id = returned id of input device for use with Octave audio subsystem
  % output_id = returned id of output device for use with Octave audio subsystem
  % name = "2i2" to search for Focusrite Scarlett 2i2 device
  %
  % Worked on Win10 / Octave 8.3.0, doesn't work yet on Win11 / Octave 8.3.0...player
  
  n_input = audiodevinfo(1)/2; % How many input devices are there?
  n_output = audiodevinfo(0)/2; % How many output devices are there?
 
  % Find the input device with "name"
  input_id = -1; % Initially mark as error
  for n=0:n_input-1
    p = audiodevinfo(1,n);
    if (length(strfind(p, name)) > 0)
      input_id = n;
    end
  end

  % Find the output device with "name"
  output_id = -1; % Initially mark as error
  for n=n_input:n_input+n_output-1
    p = audiodevinfo(0,n);
    if (length(strfind(p, name)) > 0)
      output_id = n;
    end
  end
  
  if (input_id == -1)
    error ("Input device not found")
  end
  if (output_id == -1)
    error ("Output device not found")
  end

endfunction


