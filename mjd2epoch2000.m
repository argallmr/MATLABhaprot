%--------------------------------------------------------------------------
% NAME
%   mjd2epoch2000
%
% PURPOSE
%
%   Convert Modified Julian Date (mjd) to Epoch 2000
%       mjd         -- Fractional number of days since 00:00 UT 17-Nov-1858
%       Epoch2000   -- Fractional number of days since 12:00 UT 01-Jan-2000
%
%   Original comments by Roy Torbret:
%       This calculates the Modified Julian Date.
%       This is the days since 17 Nov 1858 ( at 00:00 UT )
%       replaces the machine-dependent piece of shit
%       provided by Hapgood.
%
% Calling Sequence:
%   epoch2000 = date2mjd(mjd)
%       Convert modified Julian date to Epoch 2000.
%
% INPUTS
%   MJD:            in, required, type=double
%                   Number of days since 17 Nov 1858 at 00:00 UT, which is
%                       the definition of Modified Julian Date.
%
% RETURNS
%   EPOCH2000:      out, required, type=double
%                   Number of days since 01 Jan 2000 at 12:00 UT, which is
%                       the definition of Epoch 2000.
%--------------------------------------------------------------------------
function epoch2000 = mjd2epoch2000(mjd)
    % Time in Julian centruies from Epoch 2000 (12:00 UT, 1 Jan. 2000)
    %   - mjd        starts 00:00 UT 17-Nov-1858
    %   - Epoch 2000 starts 12:00 UT 01-Jan-2000
    %   - datestr( 51544.5 + datenum(1858, 11, 17)) = 01-Jan-2000 12:00:00
    epoch2000 = mjd - 51544.5;
end
