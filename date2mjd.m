%--------------------------------------------------------------------------
% NAME
%   date2mjd
%
% PURPOSE
%
%   Convert a date to Modified Julian Time -- the fractional number of days
%   since 00:00 UT on 17 Nov. 1858.
%
%   Original comments by Roy Torbret:
%       This calculates the Modified Julian Date.
%       This is the days since 17 Nov 1858 ( at 00:00 UT )
%       replaces the machine-dependent piece of shit
%       provided by Hapgood.
%
% Calling Sequence:
%   mjd = date2mjd(year, month, day)
%       Calculate the modified Julian date from the numeric year, month and
%       day.
%
%   mjd = date2mjd(date)
%       Calulate the modified Julian date from a date string, Nx10
%       character array, or 1xN element cell array of strings, where N
%       represents the number of dates formatted as 'yyyy-mm-dd'.
%
%
% INPUTS
%   YEAR:           in, required, type=double
%                   Year in which the data was collected.
%   MONTH:          in, required, type=double
%                   Month in which the data was collected.
%   DAY:            in, required, type=string
%                   Day in which the data was collected.
%
% RETURNS
%   MJD:            out, required, type=double
%                   Number of days since 17 Nov 1858 at 00:00 UT, which is
%                       the definition of Modified Julian Date.
%--------------------------------------------------------------------------
function mjd = date2mjd(year, month, day)

    % A single argument?
    if nargin == 1
        % Concatenate into a character array
        if iscell(year)
            year = vertcat(year{:});
        end
        
        % Convert to numeric year, month, day.
        year  = str2num(year(:, 1:4));
        month = str2num(year(:, 6:7));
        day   = str2num(year(:, 9:10));
    end

    % Modified Julian Date
    %   - Fractional number of days since 17 Nov. 1858
    %   - datenum(1858, 11, 17) = 678942
    mjd = datenum(year, month, day) - 678942 ;
end
