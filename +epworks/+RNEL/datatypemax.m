function val = datatypemax(data,returnasdouble)
% DATATYPEMAX Returns the maximum value for a numeric data type
%
% val = datatypemax(data,*returnasdouble)
%
% INPUTS
% =========================================================================
%   data           - (numeric) example data, used to get representation
%   returnasdouble - (logical) Default: false. Whether value is returned as 
%   a double or matching source type
%
% OUTPUTS
% =========================================================================
%   val - (numeric)
%
%
% see also: realmax,realmin,intmax,intmin

if nargin < 2
    returnasdouble = true;
end

if ischar(data)
    data_type = data;
else
    data_type = class(data);
end

switch lower(data_type)
    case {'double','single'}
        val = realmax(data_type);
    otherwise
        val = intmax(data_type);
end
if returnasdouble
    val = double(val);
end
end