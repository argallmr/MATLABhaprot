%--------------------------------------------------------------------------
% Name
%   date2julday
%
% Purpose
%   Julian day number 0 assigned to the day starting at noon on
%   January 1, 4713 BC, proleptic Julian calendar (November 24, 4714 BC,
%   in the proleptic Gregorian calendar). See Hapgood Rotations Glossary.txt.
%
% Calling Sequence:
%   julday = date2julday (DateNumber)
%   Convert MATLAB date number to julian days.
%
%   julday = date2julday (DateString)
%   Convert a date string to julian days. See MATLAB help for datevec.
%
%   julday = date2julday (Date, format)
%   Convert date strings to julian days. FORMAT specifies how the
%   strings are formatted. See MATLAB help for datevec.
%
%   julday = date2julday (__, 'MJD', {true | false})
%   Return the modified Julian Day instead of the Julian Day.
%
% Examples:
%   >> date2julday (datenum (2000, 01, 01, 12, 0, 0))    ACCEPTED
%   2451545.0                                            2451545.0
%
%   >> date2julday (datenum (2014, 10, 08, 14, 13, 0))
%   2456939.092361                                       2456939.092361
%
%   >> date2julday ('2014-10-08T14:13:00', 'yyyy-mm-ddTHH:MM:SS'))
%   2456939.092361                                       2456939.092361
%
% References:
%   http://en.wikipedia.org/wiki/Julian_day
%   http://www.cs.utsa.edu/~cs1063/projects/Spring2011/Project1/jdn-explanation.html
%   http://articles.adsabs.harvard.edu/full/1983IAPPP..13...16F
%   http://aa.usno.navy.mil/data/docs/JulianDate.php
%--------------------------------------------------------------------------
function julday = date2julday (Date, varargin)

  % Default
  mjd = false;
  fmt = '';

  % Optional Inputs
  if nargin >= 2
    % Date string?
    %   - Format is the only non-[name, value] option.
    if mod (length (varargin), 2) ~= 0
      fmt = varargin {1};
    end

    % Modified Julian Date?
    iMJD = find (strcmp (varargin, 'MJD') == 1);
    if ~isempty (iMJD)
      mjd = logical (varargin {iMJD + 1});
    end
  end

  % DateNum or Date string?
  if isempty (fmt)
    [year, month, day, hour, minute, second] = datevec (Date);
  else
    [year, month, day, hour, minute, second] = datevec (Date, fmt);
  end

  %
  % Values
  %   1 for January & February
  %   0 for all other months
  a = floor ( (14 - month) / 12 );

  % Offset months so year starts in March
  %   m = 10 -- January
  %   m = 11 -- February
  %   m =  0 -- March
  m = month + 12*a - 3;

  % Offset the year so that we begin counting on 1 March -4800 (4801 BC).
  %   - Subtract a year for Jan and Feb
  %   - (The year does not begin until March)
  %
  %   1 AD = 1
  %   1 BC = 0
  %   2 BC = -1
  %   3 BC = -2
  %   etc.
  y = year + 4800 - a;

  % Julian Day Number
  %   1.   Number of days in current month
  %   2.   Number of days in previous months
  %       Mar?Jul:  31 30 31 30 31
  %       Aug?Dec:  31 30 31 30 31
  %       Jan?Feb:  31 28
  %   3.   Number of days in previous years
  %   4-6. Number of leap days since 4800
  %       - Every year that is divisible by 4
  %       - Except years that are divisible by 100 but not by 400.
  %   7.   Ensure JND=0 for January 1, 4713 BC.
  JDN = day                              + ...
        floor ( (153.0 * m + 2.0) / 5.0) + ...
        365.0 * y                        + ...
        floor (y /   4.0)                - ...
        floor (y / 100.0)                + ...
        floor (y / 400.0)                - ...
        32045.0;

  % Add the fractional part of the day
  %   - Julian day begins at noon.
  julday = JDN + (hour - 12.0) / 24.0 + minute / 1440.0 + second / 86400.0;

  % Modified Julian Day?
  %   - Days since 17 Nov 1858 00:00 UT
  if mjd
  	julday = julday - 2400000.5;
  end
end

%----------------------------
% Alternative Methods
%----------------------------
%    % See http://articles.adsabs.harvard.edu/full/1983IAPPP..13...16F
%
%    % Valid for all Gregorian Calendar dates
%    JD = 367 * year - ...
%      7 * floor ( (   year + floor ( (month + 9) / 12) ) / 4 ) - ...
%      3 * floor ( ( ( year + floor ( (month - 9) /  7) ) / 100 + 1 ) / 4 ) + ...
%      floor (275 * month / 9)  + ...
%      day + ...
%      1721020;
%
%    % Valid for dates after March 1900
%    JD = 367 * year - ...
%      7 * floor ( ( year + floor ( (month + 9) / 12) ) / 4 ) + ...
%      floor (275 * month / 9) + ...
%      1721014;
%---------------------------