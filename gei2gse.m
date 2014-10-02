%--------------------------------------------------------------------------
% NAME
%   gei2gse
%
% PURPOSE
%   Produce a transformation from GEI to GSE.
%
%   References:
%       - https://www.spenvis.oma.be/help/background/coortran/coortran.html
%       - Hapgood, M. A. (1992). Space physics coordinate transformations:
%           A user guide. Planetary and Space Science, 40(5), 711?717. 
%           doi:http://dx.doi.org/10.1016/0032-0633(92)90012-D
%       - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%           45(8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633(97)80261-9
%
% INPUTS
%   MJD:            in, required, type=double
%                   Modified julian date.
%   UT:             in, required, type=double
%                   Universal Time in hours since midnight.
%
% RETURNS
%   T3:             out, required, type=double
%                   Transformation matrix from GEI to GSE.
%--------------------------------------------------------------------------
function T2 = gei2gse(mjd,ut)
    % Convert degrees to radians.
    deg2rad = pi/180;
    
    % Number of julian centuries since Epoch 2000
    T0 = nJulCenturies( mjd2epoch2000( fix(mjd) ) );
    
    % Axial tilt
    obliq = earth_obliquity(T0)            * deg2rad;
    eLon  = sun_ecliptic_longitude(T0, ut) * deg2rad;
    
    %
    % The transformation from GEI to GSE, then is
    %   - T2 = <eLon, Z> <obliq, X>
    %   - A pure rotation about Z by angle obliq
    %   - A pure rotation about X by angle elon
    %
    
    % <obliq, X>
    sob = sin( obliq );
    cob = cos( obliq);
    T21 = [ 1    0    0;  ...
            0   cob  sob; ...
            0  -sob  cob];
    
    % <eLon, X>
    sol = sin(eLon);
    col = cos(eLon);
    T22 = [ col  sol  0; ...
           -sol  col  0; ...
             0    0   1];
         
    % Rotation from GEI to GSE
    T2 = T22*T21;
end
