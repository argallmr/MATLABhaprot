%--------------------------------------------------------------------------
% NAME
%   geo2mag
%
% PURPOSE
%   Produce a transformation from GEO to MAG. It involves two rotations:
%   one in the plane of the Earth's equator from the Greenwich meridian to
%   the meridian containing the dipole pole, and another rotation in that
%   meridian from the geographic pole to the dipole pole.
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
%       T5 = gse2gsm(phi, lambda)
%           PHI and LAMBDA are the geocentric latitude and longitude of the
%           dipole North geomagnetic pole (GEO spherical coordinates).
%
%       T5 = gse2gsm(g01, g11, h11, MJD, UT)
%           First order IGRF coefficients, adjusted to the time of
%           interest.
%
% RETURNS
%   T5:             out, required, type=double
%                   Transformation matrix from GEO to MAG.
%--------------------------------------------------------------------------
function T5 = geo2mag(arg1, arg2, arg3)

    % Dipole axis.
    switch nargin
        case 3
            g01 = arg1;
            g11 = arg2;
            h11 = arg3;
            [phi, lambda] = dipole_axis(g01, g11, h11);
        case 2
            phi    = arg1;
            lambda = arg2;
        otherwise
            error('Incorrect number of arguments.');
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Form the Transformation Matrix    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % The transformation from GSM to SM, then is
    %   - T4 = <phi - 90, Y> <lambda, Z>
    %   - A pure rotation about Z by angle lambda
    %   - A pure rotation about Y by angle (phi - 90)
    
    % <lambda, Z>
    sinlam = sin(lambda);
    coslam = cos(lambda);
    T51 = [  coslam  sinlam  0;
            -sinlam  coslam  0;
                0       0    1];
    
    % <(phi - 90, Y>
    sinphi = sin( phi - pi/2 );
    cosphi = cos( phi - pi/2 );
    T52 = [  cosphi  0  sinphi  ; ...
              0    1    0    ; ...
           -sinphi  0  cosphi ];
       
   % Create the transformation
   T5 = T52 * T51;
end
