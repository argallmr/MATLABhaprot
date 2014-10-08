%--------------------------------------------------------------------------
% NAME
%   gei2gse
%
% PURPOSE
%   Produce a transformation from GEI to GEO. It is a rotation in the plane
%   of Earth's geographic equator from the First Point of Aries to the
%   Greenwich meridian. The rotation angle is known as the Greenwich Mean
%   Sidreal Time.
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
%       T1 = gei2geo(date, UT)
%           Rotate from GEI to GEO given date(s) in the format
%           'yyyy-mm-dd'. date can be a string, cell array of strings, or
%           an Nx10 character array. UT is the fractional number of hours
%           on the date of interest.
%
%       T1 = gei2geo(mjd, ...)
%           Rotate from GEI to GEO given modified Julian date, ...
%
% INPUTS
%   MJD:            in, required, type=double
%                   Modified julian date.
%   UT:             in, required, type=double
%                   Universal Time in hours since midnight.
%
% RETURNS
%   T0:             out, required, type=double
%                   Rotation matrix from GEI to GSO
%--------------------------------------------------------------------------
function T1 = gei2geo(mjd, UT)
    
    % Convert a date to modified Julian date?
    if ischar(mjd) || iscell(mjd)
        mjd = date2mjd(mjd);
    end
    
    % Number of julian centuries since Epoch 2000
    T0 = nJulCenturies( mjd2epoch2000( fix(mjd) ) );
    
    % Compute the sidereal time
    theta = gmSiderealTime(T0, UT) * pi/180;
    
    %
    % The transformation from GEI to GEO, then is
    %   - T1 = <theta, Z>
    %   - A pure rotation about Z by angle theta
    %
    
    % <obliq, X>
    sintheta = sin(theta);
    costheta = cos(theta);
    T1 = [ 1      0          0;    ...
           0   costheta  sintheta; ...
           0  -sintheta  costheta];
end
