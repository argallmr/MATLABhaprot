%--------------------------------------------------------------------------
% NAME
%   ISOdate2mjd
%
% PURPOSE
%   Convert a date to Modified Julian Date -- the fractional number of days
%   since 00:00 UT on 1858-11-17.
%
% Calling Sequence:
%   mjd = ISOdate2mjd (year, month, day)
%   Calculate the Modified Julian Date from the numeric year, month and day.
%
%   mjd = ISOdate2mjd (date)
%   Calulate the Modified Julian Date from a date string, Nx10
%   character array, or 1xN element cell array of strings, where N
%   represents the number of dates formatted as 'yyyy-mm-dd'.
%
% INPUTS
%   YEAR:           in, required, type = double
%   MONTH:          in, required, type = double
%   DAY:            in, required, type = double
%
% RETURNS
%   MJD:            out, required, type = double
%
% MATLAB release(s) MATLAB 7.12 (R2011a)
% Required Products None
%--------------------------------------------------------------------------
function mjd = ISOdate2mjd (year, month, day)

  % If only 1 argument passed, expect it to be an ISO date yyyy-mm-dd of some sort.
  if nargin == 1
    % Concatenate into a character array
    if iscell (year)
      year = vertcat (year {:});
    end
    
    % Convert to numeric year, month, day.
    year  = str2num (year (:, 1:4) );
    month = str2num (year (:, 6:7) );
    day   = str2num (year (:, 9:10));
  end

  % Adjust date using MATLAB datenum base
  % datenum (1858, 11, 17) = 678942.0
  mjd = datenum (year, month, day) - 678942.0;
end

% Test cases and results:
