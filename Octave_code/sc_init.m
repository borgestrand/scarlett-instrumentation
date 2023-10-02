% Initiate default variables
% Usage: defaults = sc_init(fs, resolution, dac_util, adc_util);
% defaults = initiates global variable
% fs = sample rate, typically 96000
% resolution = bith depth in ADC and DAC, typically 24. May not always perform at 24 bits in Win11
% dac_util = DAC utilization. Must be less than 1. Suggested level = 0.9
% adc_util = ADC utilization. Likely 0.5 triggers transition from green to orange light. Suggested: 0.45

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

function defaults = sc_init(fs, resolution)
  % Input parameters
  defaults.fs = fs;
  defaults.resolution = resolution;
  defaults.dac_util = dac_util;
  defaults.adc_util = adc_util;
  
  % Derived defaults
  [defaults.input_id defaults.output_id] = sc_identify_device("2i2");

endfunction


