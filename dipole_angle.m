%--------------------------------------------------------------------------
% NAME
%   dipole_angle
%
% PURPOSE
%   Compute the angle between the dipole axis and the z-GSE and z-GSM axes.
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
%       [TILT, PSI] = gse2gsm(X, Y, Z)
%           Returns TILT, the dipole tilt angle to the z-GSM axis, and PSI,
%           the angle between z-GSE and the projection of the magnetic
%           dipole onto the GSE YZ-plane (i.e. z-GSM) measured positive for
%           rotations toward the GSE Y-axis. Inputs X, Y and Z are the x-,
%           y- and z-components of the unit vector describing the dipole
%           axis direction in GSE.
%
%       [...] = gse2gsm(phi, lambda, MJD, UT)
%           PHI and LAMBDA are the geocentric latitude and longitude of the
%           dipole North geomagnetic pole (GEO spherical coordinates). MJD
%           is the modified Julian date measured until 00:00 UT on the date
%           of interest. UT is Universal Time in fractional number of
%           hours.
%
%       [...] = gse2gsm(g01, g11, h11, MJD, UT)
%           First order IGRF coefficients, adjusted to the time of
%           interest. Distinguished from (x, y, z) by the true flag. MJD
%           is the modified Julian date measured until 00:00 UT on the date
%           of interest. UT is Universal Time in fractional number of
%           hours.
%--------------------------------------------------------------------------
function [tilt, psi] = dipole_angle(arg1, arg2, arg3, arg4, arg5)

    % Correct number of arguments given?
    assert(nargin > 0 && nargin < 6, 'Incorrect number of arguments.');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % IGRF Coefficients Given %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin == 5
        g01 = arg1;
        g11 = arg2;
        h11 = arg3;
        mjd = arg4;
        UT  = arg5;

        % Compute the geocentric longitude and lattitude of the dipole.
        [phi, lambda] = dipole_axis(g01, g11, h11);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Geocentric Longitude and Latitude %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin >= 4
        if nargin == 4
            phi    = arg1;
            lambda = arg2;
            mjd    = arg3;
            UT     = arg4;
        end

        % Unit vector of the dipole axis in GEO
        Qg = [ cos(phi)*sin(lambda); ...
               cos(phi)*sin(lambda); ...
                    sin(phi)        ];

        % Rotations to bring GEO to GSE
        T1 = gei2geo(mjd, UT);
        T2 = gei2gse(mjd, UT);

        % Rotate the dipole axis to GSE
        Qe = T2 * T1' * Qg;
        x  = Qe(1);
        y  = Qe(2);
        z  = Qe(3);
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Unit Vector of Dipole in GSE      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin == 3
        x = arg1;
        y = arg2;
        z = arg3;
    end
    
    % Compute the angles
    psi = atan(y/z);
    tilt = atan( x / sqrt(y^2 + z^2) );
end
