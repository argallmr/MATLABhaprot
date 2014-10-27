%--------------------------------------------------------------------------
% Name
%   gei2geo
%
% Purpose
%   Produce a transformation from GEI to GEO. It is a rotation in the plane
%   of Earth's geographic equator from the First Point of Aries to the
%   Greenwich meridian. The rotation angle is known as the Greenwich Mean
%   Sidereal Time.
%
%   Calling Sequence:
%   T1 = gei2geo (date, UTC)
%   Rotate from GEI to GEO, given date (s) in the format
%   'yyyy-mm-dd'. date can be a string, cell array of strings, or
%   an Nx10 character array. UTC is the decimal number of hours
%   on the date of interest.
%
%   T1 = gei2geo (mjd, ...)
%   Rotate from GEI to GEO given Modified Julian Date, ...
%
% Inputs
%   MJD:   in, required, type = double
%   UTC:   in, required, type = double
%
% Returns
%   T0:    out, required, type = double
%          Rotation matrix from GEI to GSO
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
function T1 = gei2geo (mjd, UTC)

	assert (nargin > 1, 'Missing arguments for gei2geo ().');

	% Convert a date to Modified Julian Date?
	if ischar (mjd) || iscell (mjd)
		mjd = date2mjd (mjd);
	end

	% Number of julian centuries since Epoch 2000
	T0 = nJulCenturies ( mjd2epoch2000 ( fix (mjd)) );

	% Compute the sidereal time
	theta = GreenwhichMeanSiderealTime (T0, UTC);

	% The transformation from GEI to GEO, then is
	%   - T1 = <theta, Z>
	%   - A CW pure rotation about Z by angle theta

	% <obliq, X>
	sinTheta = sin (theta);
	cosTheta = cos (theta);
	T1 = [ cosTheta  sinTheta  0; ...
        -sinTheta  cosTheta  0; ...
            0         0      1];
end
