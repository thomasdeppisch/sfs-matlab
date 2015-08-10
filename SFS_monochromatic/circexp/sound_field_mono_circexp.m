function [P, x, y, z] = sound_field_mono_circexp(X,Y,Z,Pm,mode,f,xq,conf)
%SOUND_FIELD_MONO_CIRCEXP yields a sound field given with regular/singular
%spherical expansion coefficients
%
%   Usage: [P, x, y, z] = sound_field_mono_circexp(X,Y,Z,Pm,mode,f,xq,conf)
%
%   Input parameters:
%       X           - x-axis / m; single value or [xmin,xmax] or nD-array
%       Y           - y-axis / m; single value or [ymin,ymax] or nD-array
%       Z           - z-axis / m; single value or [zmin,zmax] or nD-array
%       Pm          - regular/singular spherical expansion coefficients
%       mode        - 'R' for regular, 'S' for singular
%       f           - frequency in Hz
%       xq          - optional expansion center coordinates, default: [0, 0, 0]
%       conf        - optional configuration struct (see SFS_config)
%
%   Output parameters:
%       P           - resulting soundfield
%
%   SOUND_FIELD_MONO_CIRCEXP(X,Y,Z,Pm,mode,f,xq,conf)
%
%   see also: circbasis_mono_grid, sound_field_mono_circbasis

%*****************************************************************************
% Copyright (c) 2010-2014 Quality & Usability Lab, together with             *
%                         Assessment of IP-based Applications                *
%                         Telekom Innovation Laboratories, TU Berlin         *
%                         Ernst-Reuter-Platz 7, 10587 Berlin, Germany        *
%                                                                            *
% Copyright (c) 2013-2014 Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock           *
%                                                                            *
% This file is part of the Sound Field Synthesis-Toolbox (SFS).              *
%                                                                            *
% The SFS is free software:  you can redistribute it and/or modify it  under *
% the terms of the  GNU  General  Public  License  as published by the  Free *
% Software Foundation, either version 3 of the License,  or (at your option) *
% any later version.                                                         *
%                                                                            *
% The SFS is distributed in the hope that it will be useful, but WITHOUT ANY *
% WARRANTY;  without even the implied warranty of MERCHANTABILITY or FITNESS *
% FOR A PARTICULAR PURPOSE.                                                  *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy  of the GNU General Public License  along *
% with this program.  If not, see <http://www.gnu.org/licenses/>.            *
%                                                                            *
% The SFS is a toolbox for Matlab/Octave to  simulate and  investigate sound *
% field  synthesis  methods  like  wave  field  synthesis  or  higher  order *
% ambisonics.                                                                *
%                                                                            *
% http://github.com/sfstoolbox/sfs                      sfstoolbox@gmail.com *
%*****************************************************************************

%% ===== Checking of input  parameters ==================================
nargmin = 6;
nargmax = 8;
narginchk(nargmin,nargmax);
isargvector(Pm);
if mod(size(Pm, 1)-1, 2) ~= 0
  error('Number of row of %s has be to odd', inputname(Pm));
end
isargnumeric(X,Y,Z);
isargpositivescalar(f);

if nargin<nargmax
    conf = SFS_config;
else
    isargstruct(conf);
end

if nargin == nargmin
  xq = [0, 0, 0];
else
  isargposition(xq);
end

%% ===== Variables ======================================================
Nce = ( size(Pm, 1) - 1 ) / 2;

%% ===== Computation ====================================================
if strcmp('R', mode)
  [fn, ~, Ym, x, y, z] = circbasis_mono_grid(X,Y,Z,Nce,f,xq,conf);
elseif strcmp('S', mode)
  [~, fn, Ym, x, y, z] = circbasis_mono_grid(X,Y,Z,Nce,f,xq,conf);
else
  error('%s: %s is an unknown mode!',upper(mfilename), mode);
end

P = sound_field_mono_circbasis(Pm,fn,Ym);

end