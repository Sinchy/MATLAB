function varname = createUniqueName(baseString)
% Easy creation of unique variable name (evaluated in base workspace)
%
% Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 01/07/2015

% Copyright The MathWorks, Inc. 2015

n = 0; tmp = 1;
while tmp
	n = n + 1;
	tmp = evalin('base',['exist(''', baseString, num2str(n),''',''var'')']);
end
varname = [baseString, num2str(n)];