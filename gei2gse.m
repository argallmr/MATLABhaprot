%--------------------------------------------------------------------------
% Name
%   gei2gse
%
% Purpose
%   Produce a rotation matrix from GEI to GSE.
%
% Inputs
%   MJD:   in, required, type = double
%          Modified Julian Date.
%   UTC:   in, required, type = double
%          UTC in decimal hours since midnight.
%
% Returns
%   T3:    out, required, type = double
%          Totation matrix from GEI to GSE.
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
function T2 = gei2gse (mjd, UTC)

	assert (nargin > 1, 'Missing arguments for gei2gse ().');
	Hapgood_rotations_lib

	% Number of julian centuries since Epoch 2000
	T0 = nJulCenturies ( mjd2epoch2000 ( fix (mjd)) );

	% Axial tilt
	obliq = earth_obliquity (T0)             * deg2rad;
	eLon  = sun_ecliptic_longitude (T0, UTC) * deg2rad;

	%
	% The transformation from GEI to GSE, then is
	%   - T2 = <eLon, Z> <obliq, X>
	%   - A pure rotation about X by angle obliq
	%   - A pure rotation about Z by angle eLon
	%

	% <obliq, X>
	sinObliq = sin ( obliq );
	cobObliq = cos ( obliq);
	T21 = [ 1    0    0;  ...
					0   cobObliq  sinObliq; ...
					0  -sinObliq  cobObliq];

	% <eLon, X>
	sinLon = sin (eLon);
	cosLon = cos (eLon);
	T22 = [ cosLon  sinLon  0; ...
				 -sinLon  cosLon  0; ...
					 0    0   1];

	% Rotation from GEI to GSE
	T2 = T22*T21;
end
