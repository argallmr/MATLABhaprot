%--------------------------------------------------------------------------
% Name
%   dipole_axis
%
% Purpose
%   Calculate the position of the dipole in spherical GEO coordinates.
%
% Calling Sequence:
%   [lat, lon] = dipole_axis (g01, g11, h11)
%   Inputs G01, G11, and H11 are the first order IGRF coefficients,
%   adjusted to the time of interest. Angles are returned in
%   radians.
%   lat and lon are the (GEO) geocentric (radians) latitude and longitude
%   of the dipole north geomagnetic pole. MJD is the Modified Julian Date.
%   UTC is in decimal hours.
%
% See Also:
%   dipole_tilt_angle.m
%
% References:
% See Hapgood Rotations Glossary.txt.
% - https://www.spenvis.oma.be/help/background/coortran/coortran.html
% - Hapgood, M. A. (1992). Space physics coordinate transformations:
%   A user guide. Planetary and Space Science, 40 (5), 711?717.
%   doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
% - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%   45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% Last update: 2014-10-14
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%--------------------------------------------------------------------------
function [lat, lon] = dipole_axis (g01, g11, h11)

	assert (nargin == 3, 'Missing arguments for dipole_axis ().'); % nargin > 2 ?

	% Compute the geocentric longitude and lattitude of the dipole.
	lon = atan (h11 / g11);
	lat = pi / 2.0 - atan ( (g11 * cos (lon) + h11 * sin (lon)) / g01 );
end
