%--------------------------------------------------------------------------
% Name
%   nJulCenturies
%
% Purpose
%   Given a fractional number of days, compute the number of Julian Centuries.
%
% Calling Sequence:
%   nJC = date2mjd (nDays)
%       Compute the number of Julian Centuries in a certain number of days.
%
% Inputs
%   NDAYS: in, required, type = double
%          Fractional number of days (could be from a given epoch,
%          such as Epoch 2000, the Modified Julian Date, etc.).
%
% Returns
%   nJC:   out, required, type = double
%          Number of Julian Centuries.
%
% References:
% See Hapgood Rotations Glossary.txt.
% - https://www.spenvis.oma.be/help/background/coortran/coortran.html
% - Hapgood, M. A. (1992). Space physics coordinate transformations:
%   A user guide. Planetary and Space Science, 40 (5), 711?717.
%   doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
% - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%   45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% Last update: 2014-10-14
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%--------------------------------------------------------------------------
function nJC = nJulCenturies (nDays)

	assert (nargin > 1, 'Missing arguments for nJulCenturies ().');

	% There are exactly 36525 days in a Julian Century
	nJC = nDays / 36525.0;
end
