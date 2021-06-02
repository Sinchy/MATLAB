function plotColumns(data, varargin)
% plotColums(data, varargin)
% 
% Pass in a matrix where the rows are the data points (and the columns are
% X, Y, and Z respectively). Each column will be passed to 
% plot (if two columns) or plot3 (if 3 columns).
% Remaining arguments (such as formatting commands) will be passed directly 
% through. Operates on gcf, gca
%
% @param[in] data - N x [2,3] matrix, where each column is the X, Y, [and
% Z] data respectively. 
%
% @param[in] varargin - any remaining arguments (formatting commands) are
% passed directly through to plot or plot3
%
if size(data,2) == 1
    plot(data, varargin{:});
elseif size(data,2) == 2
    plot(data(:,1), data(:,2), varargin{:});    
elseif size(data,2) == 3
    plot3(data(:,1), data(:,2), data(:,3), varargin{:});
else
    error('columnPlot: data has more than 3 columns can cannot be plotted with plot or plot3');
end
end