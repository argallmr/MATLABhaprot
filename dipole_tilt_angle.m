%--------------------------------------------------------------------------
% Name
%   dipole_tilt_angle
%
% Purpose
%   Compute the angle between the dipole axis and the GSEz and GSMz axes.
%
% Calling Sequence:
%   [dipoleAngle2GSMz, GSMzAngle2GSEz] = dipole_tilt_angle (x, y, z)
%   Returns the dipole tilt angle and psi, the angle twixt GSMz GSEz.
%   (x, y, z) are the x-, y- and z-components of the UNIT vector
%   describing the direction of the north magnetic dipole in GSE.
%
%   [...] = dipole_tilt_angle (lat, lon, MJD, UTC)
%   lat and lon are the (radian) (GEO) geocentric latitude and longitude of the
%   dipole north geomagnetic pole. MJD is the Modified Julian Date.
%   UTC is in decimal hours.
%
%   [...] = dipole_tilt_angle (g01, g11, h11, MJD, UTC)
%   First order IGRF coefficients, adjusted to the time of interest.
%   Distinguished from (x, y, z) by the true flag. MJD is the Modified
%   Julian Date. UTC is in decimal hours.
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
function [dipoleAngle2GSMz, GSMzAngle2GSEz] = dipole_tilt_angle (arg1, arg2, arg3, arg4, arg5)

	assert (nargin > 0, 'Missing arguments for dipole_tilt_angle ().');

	switch nargin
		case 3
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Unit Vector of Dipole in GSE %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			x = arg1;
			y = arg2;
			z = arg3;

		case 4
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Geocentric Longitude and Latitude %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			lat = arg1;
			lon = arg2;
			MJD = arg3;
			UTC = arg4;

		case 5
			%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% IGRF Coefficients Given %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%
			g01 = arg1;
			g11 = arg2;
			h11 = arg3;
			MJD = arg4;
			UTC = arg5;

			% Compute the geocentric longitude and lattitude of the dipole.
			[lat, lon] = dipole_axis (g01, g11, h11);
	end % switch

	% Geocentric Longitude and Latitude, continued
	if nargin >= 4
		% Unit vector of the dipole axis in GEO
		Qg = [ cos(lat)*cos(lon);
					 cos(lat)*sin(lon);
					 sin(lat)             ];

		% Rotations to bring GEO to GSE
		T1 = gei2geo (MJD, UTC);
		T2 = gei2gse (MJD, UTC);
		geo2gse = T2 * T1'; % to prepare for handling matrices, rather than a single vector

		% Rotate the dipole axis to GSE
		Qe = geo2gse * Qg;
		x  = Qe (1);
		y  = Qe (2);
		z  = Qe (3);
	end

	% Compute the angles - handle matrices - quadrant-safe because Lat & Lon are constrained
	dipoleAngle2GSMz = atan ( x ./ sqrt (y.^2 + z.^2) );
	GSMzAngle2GSEz   = atan (y ./ z);
end

% Test cases and results
% (x, y, z)
% [0.05, 0.05, 0.95] ./ norm ([0.05, 0.05, 0.95], 2) = [ 0.052486 0.052486 0.99724 ]
% dipole_tilt_angle (0.052486, 0.052486, 0.99724) = 0.05251

% (lat, lon, MJD, UTC), MJD (2014-10-14) = 56944
% WMM2010 coefficients for 2010.0 the geomagnetic north pole: 80.08°N latitude, 72.21°W longitude (287.79)
% dipole_tilt_angle (lat, lon, MJD, UTC) => dipole_tilt_angle (80.08, 287.79, 56944, 0.0) = 0.029236
