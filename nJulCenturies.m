%--------------------------------------------------------------------------
% NAME
%   nJulCenturies
%
% PURPOSE
%   Given a fractional number of days, compute the number of Julian
%   Centuries.
%
% Calling Sequence:
%   nJC = date2mjd(nDays)
%       Compute the number of Julian Centuries in a certain number of days.
%
% INPUTS
%   NDAYS:          in, required, type=double
%                   Fractional number of days (could be from a given epoch,
%                    such as Epoch 2000, the modified Julian date, etc.).
%
% RETURNS
%   nJC:            out, required, type=double
%                   Number of Julian Centuries.
%--------------------------------------------------------------------------
function nJC = nJulCenturies(nDays)
    % There are exactly 36525 days in a Julian Century
    nJC = nDays / 36525;
end
