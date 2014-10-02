%--------------------------------------------------------------------------
% NAME
%   sun_mean_longiude
%
% PURPOSE
%   Compute the sun's mean longiude.
%
%   Note:
%       Strictly speaking, TDT (Terrestrial Dynamical Time) should be used
%       here in place of UT, but the difference of about a minute gives a
%       difference of about 0.0007° in lambdaSun.
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
%       lambda = sun_mean_anomoly(T0, UT)
%           Compute the sun's mean longitude (degrees) given the number
%           of julian centruies (T0) from 12:00 UT 01-Jan-2000 until
%           00:00 UT on the day of interest, and Universal Time (UT) in
%           fractional number of hours.
%
%
% INPUTS
%   T0:             in, required, type=double
%                   Time in Julian centuries calculated from 12:00:00 UT
%                       on 1 Jan 2000 (known as Epoch 2000) to the previous
%                       midnight. It is computed as:
%                           T0 = (MJD - 51544.5) / 36525.0
%   UT:             in, required, type=double
%                   
%
% RETURNS
%   LAMBDA:         out, required, type=double
%                   Mean longitude of the sun, in degrees.
%--------------------------------------------------------------------------
function lambda = sun_mean_longitude(T0, UT)
    % Sun's Mean anomoly
    %   - Force to the range [0, 360)
    lambda = mod(280.460 + 36000.772*T0 + 0.04107*UT, 360);
end