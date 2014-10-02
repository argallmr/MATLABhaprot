%--------------------------------------------------------------------------
% NAME
%   gmSideRealTime
%
% PURPOSE
%   Compute the Greenwich Mean Sidereel Time -- the angle between the
%   Greenwich meridean and the First Point of Airies, in the plane of the
%   geographic equator.
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
%   Epoch2000:      in, required, type=double
%                   Integer number of Julian centuries from 12:00 UT on
%                       1 January 2000 (i.e. Epoch 2000), i.e. the Julian
%                       Century at 00:00 UT on the day of interest.
%   UT:             in, required, type=double
%                   Universal Time, in decimal hours.
%
% RETURNS
%   theta:          out, required, type=double
%                   Greenwich Mean Sidereal Time.
%--------------------------------------------------------------------------
function theta = gmSiderealTime(Epoch2000, UT)
    % Compute the Greenwich Mean Sidereel Time
    theta = 100.461 + 36000.770*Epoch2000 + 15.04107*UT;
end
