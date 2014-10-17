%--------------------------------------------------------------------------
% NAME
%   dipole_axis
%
% PURPOSE
%   Calculate the position of the dipole in spherical GEO.
%
%   References:
%       - https://www.spenvis.oma.be/help/background/coortran/coortran.html
%       - Hapgood, M. A. (1992). Space physics coordinate transformations:
%           A user guide. Planetary and Space Science, 40(5), 711?717. 
%           doi:http://dx.doi.org/10.1016/0032-0633(92)90012-D
%       - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%           45(8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633(97)80261-9
%
%   Calling Sequence:
%       [PHI, LAMBDA] = gse2gsm(G01, G11, H11)
%           PHI and LAMBDA are the geocentric latitude and longitude of the
%           dipole North geomagnetic pole (GEO spherical coordinates).
%           Inputs G10, G11, and H11 are the first order IGRF coefficients,
%           adjusted to the time of interest. Angles are returned in
%           radians.
%
%   See Also:
%       dipole_tilt.m
%--------------------------------------------------------------------------
function [phi, lambda] = dipole_axis(g10, g11, h11)
    % Compute the geocentric longitude and lattitude of the dipole.
    lambda = atan(h11 / g11);
    phi    = pi/2 - atan( ( g11*cos(lambda) + h11*sin(lambda) ) / g10 );
end
