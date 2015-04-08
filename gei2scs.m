%
% Name
%   gei2scs
%
% Purpose
%   Return the transformation to the despun spacecraft frame (SCS) from
%   Geocentric Equatorial Inertial system (GEI) at the given time, with RA
%   and dec ( in degrees ) of the spin vector.
%
% Inputs
%   YEAR:    in, required, type = double
%   MONTH:   in, required, type = double
%   DAY:     in, required, type = double
%   SECS:    in, required, type = double
%            Seconds into `DAY`.
%   RA:      in, required, type = double
%            Right-ascention of the spacecraft (degrees).
%   DEC:     in, required, type = double
%            Declination of the spacecraft (degrees).
%
% Returns
%   SCS2GSE: out, optional, type = float
%            Transformation matrix to rotate SCS to GSE.
%
% References:
%   See Hapgood Rotations Glossary.txt.
%   - https://www.spenvis.oma.be/help/background/coortran/coortran.html
%   - Hapgood, M. A. (1992). Space physics coordinate transformations:
%     A user guide. Planetary and Space Science, 40 (5), 711?717.
%     doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
%   - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%     45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%
% History:
%   2014-10-14    Written by Matthew Argall
%   2015-04-08    Vectorized to accept arrays as inputs. - MRA
%
function GEI2SCS = gei2scs (year, month, day, secs, RA, dec)

	assert (nargin > 5, 'Missing arguments for gei2scs ().');
	GaSC_rotations_lib
  
	% Fractional number of days since the beginning of the year of interest.
	iday = datenum (year, month, day) - datenum (year, 1, 1) + 1;

	% Location of the sun
	SUN = sun_position (year, iday, secs);  % in what coords? normalized?

	% RA and DEC form a spherical coordinate system.
	% - RA  = number of hours past the vernal equinox (location on the
	%         celestial equator of sunrise on the first day of spring).
	% - DEC = degrees above or below the equator
	cosDec = cosd (dec);

	% [x y z] components of the unit vector pointing in the direction of
	% the spin axis.
	% - The spin axis points to a location on the suface of the celestial sphere.
	% - RA and dec are the spherical coordinates of that location,
	%   with the center of the earth as the origin.
	% - Transforming GEI to SCS transforms [0 0 1] to [x y z] = OMEGA
  % - Already normalized: spherical to cartesian with r = 1.
	gei2scs3u  = [cosd(RA)*cosDec  sind(RA)*cosDec  sind(dec)];

	% Form the X- and Y-vectors
	% - X must point in the direction of the sun.
	% - To ensure this, Y' = Z' x Sun
	% - X' = Y' x Z'
	gei2scs2  = cross (gei2scs3u, SUN);
	gei2scs2u = gei2scs2 / norm (gei2scs2, 2);
	gei2scs1  = cross (gei2scs2u, gei2scs3u);     % Should be normalized already
	gei2scs1u = gei2scs1 / norm (gei2scs1, 2);    % (cross product of 2 perp vectors)

	% Transformation from GEI to SCS.
	GEI2SCS = [ gei2scs1u; gei2scs2u; gei2scs3u];
end
