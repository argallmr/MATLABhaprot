%--------------------------------------------------------------------------
% Name
%   date2julday
%
% Purpose
%   Julian Day number 0 assigned to the day starting at noon on
%   January 1, 4713 BC, proleptic Julian calendar (November 24, 4714 BC,
%   in the proleptic Gregorian calendar). See Hapgood Rotations Glossary.txt.
%
% Calling Sequence:
%   julday = date2julday (DateNumber)
%   Convert MATLAB date number to Julian Days.
%
%   Require a format for strings, because of the performace hit if you don't.
%   julday = date2julday ({DateString, format})
%   Convert date strings to Julian Days. FORMAT specifies how the
%   strings are formatted. See MATLAB help for datevec.
%
%   julday = date2julday (__, 'MJD')
%   Return the modified Julian Day instead of the Julian Day.
%
% Examples:
%   >> date2julday (datenum (2000, 01, 01, 12, 0, 0))    ACCEPTED
%   2451545.0                                            2451545.0
%
%   >> date2julday (datenum (2014, 10, 08, 14, 13, 0))
%   2456939.092361                                       2456939.092361
%
%   Note that MATLAB 2014 datevec does not accept ISO date-time format.
%   >> date2julday ('2014-10-08 14:13:00', 'yyyy-mm-dd HH:MM:SS')
%   2456939.092361                                       2456939.092361
%
% References:
%   http://en.wikipedia.org/wiki/Julian_day
%   http://www.cs.utsa.edu/~cs1063/projects/Spring2011/Project1/jdn-explanation.html
%   http://articles.adsabs.harvard.edu/full/1983IAPPP..13...16F
%   http://aa.usno.navy.mil/data/docs/JulianDate.php
%--------------------------------------------------------------------------
function julday = date2julianDay (Date, varargin)

  % Defaults
  mjd = false;
  fmt = false;

	nVarArgs = length (varargin);

  % Optional arguments
  if nVarArgs > 0 % format | {format, MJD} | MJD
    mjd = strcmp (varargin (nVarArgs), 'MJD'); % might be MJD | format
		fmt = (~mjd | (nVarArgs == 2)); % Date string exists
  end

  % DateNum or Date string? datevec returns doubles
  if fmt
    [year, month, day, hour, minute, second] = datevec (Date, varargin {1})
  else
    [year, month, day, hour, minute, second] = datevec (Date)
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
  m = month + (12 * a) - 3;

  % Offset the year so that we begin counting on 1 March -4800 (4801 BC).
  %   - Subtract a year for Jan and Feb
  %   - (The year does not begin until March)
  %
  %   1 AD = 1
  %   1 BC = 0
  %   2 BC = -1
  %   3 BC = -2
  %   etc.
  y = (year + 4800.0) - a;

  % Julian Day Number
  %     1. Number of days in current month
  %     2. Number of days in previous months
  %        Mar-Jul:  31 30 31 30 31
  %        Aug-Dec:  31 30 31 30 31
  %        Jan-Feb:  31 28
  %     3. Number of days in previous years
  %   4-6. Number of leap days since 4800
  %        - Every year that is divisible by 4
  %        - Except years that are divisible by 100 but not by 400.
  %     7. Ensure JND=0 for January 1, 4713 BC.
  JDN = day                                + ...
        floor ( ((m * 153.0) + 2.0) / 5.0) + ...
        y * 365.0                          + ...
        floor (y / 4.0)                    - ...
        floor (y / 100.0)                  + ...
        floor (y / 400.0)                  - ...
        32045.0;

  % Add the fractional part of the day
  %   - Julian Day begins at noon.
  julday = JDN + ((hour - 12.0) / 24.0) + (minute / 1440.0) + (second / 86400.0);

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
