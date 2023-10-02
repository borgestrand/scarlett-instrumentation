% Play two sine tones on the DAC output, halt during execution
% usage: sc_sine_generator(defaults, freq_L, amplitude_L, freq_R, amplitude_R, duration);
% defaults = global configuration variable
% freq_L = the frequency in Hz to be used in the Left output channel, [0, fs/2)
% amplitude_L = the normalized amplitude for the Left channel, [0, 1)
% freq_R = the frequency in Hz to be used in the Right output channel, [0, fs/2)
% amplitude_R = the normalized amplitude for the Right channel, [0, 1)
% duration = the duration of the tone in seconds
%
% Works on Win11 / Octave 8.3.0 with manually set output_id

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

function sc_sine_generator(defaults, freq_L, amplitude_L, freq_R, amplitude_R, duration)
  n = duration * defaults.fs; % The number of samples in each tone
  output_L = amplitude_L * sin([0:n-1] * freq_L / defaults.fs * 2 * pi);
  output_R = amplitude_R * sin([0:n-1] * freq_R / defaults.fs * 2 * pi);

  y = ([output_L' output_R']);
  player = audioplayer(y, defaults.fs, defaults.resolution, defaults.output_id);
  play (player);
  while (isplaying(player)) % Halt execution durding playback
    pause(0.1);
  endwhile
  clear player; % Create and delete player for each playback

endfunction


