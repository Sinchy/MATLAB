function C = DianesColormaps(name, len, varargin)
%% Some alternatives to Matlab's built-in colormaps. All colormaps are
% designed to change in both value and hue. (Many of Matlab's colormaps just
% change in hue, and make no regularization of value, so they are very
% visually confusing.)
%
% Author: Diane H. Theriault, deht@cs.bu.edu
%
% usage: 
% colormap(DianesColormaps('name', [length]);
% 
% arguments are the same as the matlab "colormap" command
%
% @param[in] name - the name of the desired colormap
% possible colormap names: 
%   hot, cold, rainbow, hsv, graphic, redhot, lines, mono
%
% @param[in] len - the number of (interpolated) bins to return. Important
% for colorizing 3D and imagesc'ed plots.
%
% @return - the bins of the colormap (suitable for passing to matlab's
% colormap function). 
%
% If no output arguments are specified, the function
% will invoke matlab's colormap command on the current figure
%


if strcmp(name, 'hsv')

    saturation = 1;
    value = 1;
    if nargin > 2
        saturation = varargin{1};
        if nargin > 3
            value = varargin{2};
        end
    end
        
    %trying to make an equal number of bins for "hot" colors and "cold"
    %colors. Also trying to compress the green a bit, or it is perceived as
    %like half of the color map. Pure green is 120
    bins(:,1) = [ 350 310 270:-30:210 180:-40:160 140 85 60:-20:0]'/360.0;
    bins(:,2) = saturation;
    bins(:,3) = value;
    
    bins = hsv2rgb(bins)*255;
elseif strcmp(name, 'rainbow')
    saturation = 1;
    minValue = .55;
    maxValue = 1;
    if nargin > 2
        saturation = varargin{1};
    end    
    if nargin >3
        minValue = varargin{2};
        maxValue = varargin{3};
    end
    
    bins(:,1) = [280 260 240:-20:180 140 85 70:-10:10]'/360.0;
    bins(:,2) = saturation;
    brightnessDelta = maxValue-minValue;
    bins(:,3) = [minValue:brightnessDelta/(length(bins)-1):maxValue]';
    
    bins = hsv2rgb(bins)*255;
end

bins = bins/255;

if exist('len', 'var') && ~isempty(len)
    x = [0:1/(size(bins,1)-1):1];

    xprime = [0:1/(len-1):1];
    C = zeros(len,3);
    C(:,1) = interp1(x, bins(:,1), xprime);
    C(:,2) = interp1(x, bins(:,2), xprime);
    C(:,3) = interp1(x, bins(:,3), xprime);
else
    C = bins;
end

if nargout == 0
    colormap(C);
end
end

function m = magnitude(input)
    m = sqrt(sum(input.^2, 2));
end
