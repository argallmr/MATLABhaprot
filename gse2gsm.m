%--------------------------------------------------------------------------
% NAME
%   gse2gsm
%
% PURPOSE
%   Produce a transformation from GSE to GSM.
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
%       T2 = gse2gsm(PSI)
%           Calculate the rotation matrix from GSE to GSM using PSI, the
%           angle between the GSE Z-axis and the dipole axis.
%
%       T2 = gse2gsm(X, Y, Z)
%           X, Y and Z are the x-, y- and z-components of the unit vector
%           describing the dipole axis direction in GSE.
%
%       T2 = gse2gsm(phi, lambda, MJD, UT)
%           PHI and LAMBDA are the geocentric latitude and longitude of the
%           dipole North geomagnetic pole (GEO spherical coordinates). MJD
%           is the modified Julian date measured until 00:00 UT on the date
%           of interest. UT is Universal Time in fractional number of
%           hours.
%
%       T2 = gse2gsm(g01, g11, h11, MJD, UT)
%           First order IGRF coefficients, adjusted to the time of
%           interest.
%
% RETURNS
%   T3:             out, required, type=double
%                   Transformation matrix from GSE to GSM.
%--------------------------------------------------------------------------
function T3 = gse2gsm(arg1, arg2, arg3, arg4, arg5)

    % Compute the projection angle of the dipole axis.
    switch nargin
        case 5
            [~, psi] = dipole_angle(arg1, arg2, arg3, arg4, arg5);
        case 4
            [~, psi] = dipole_angle(arg1, arg2, arg3, arg4);
        case 3
            [~, psi] = dipole_angle(arg1, arg2, arg3);
        case 1
            psi = arg1;
        otherwise
            error('Incorrect number of arguments.');
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Form the Transformation Matrix    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % The transformation from GSE to GSM, then is
    %   - T2 = <psi,X> <obliq, X>
    %   - A pure rotation about Y by angle psi
    %
    
    % <psi, X>
    sinPsi = sin( psi );
    cosPsi = cos( psi );
    T3 = [ 1     0       0     ; ...
           0   cosPsi  sinPsi  ; ...
           0  -sinPsi  cosPsi ];
end
