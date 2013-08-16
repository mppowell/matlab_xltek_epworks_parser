function varargout = dealScalar(value)
%
%   epworks.sl.struct.dealScalar(value)
%

%??? Should I be using nargout and no n

varargout(1:nargout) = {value};


% if n == 0
%     if nargout
%         varargout = {value};
%     else
%         varargout = {};
%     end
% else
%     varargout    = cell(1,n);
%     varargout(:) = {value};
% end