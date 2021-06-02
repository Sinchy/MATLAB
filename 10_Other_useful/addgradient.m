function varargout = addgradient(ax,topcolor,bottomcolor)
% ADDGRADIENT   Add a nice looking gradient background to a plot
%
% ADDGRADIENT adds a subtle gray gradient background to the current plot
%
% ADDGRADIENT(AX) adds the gradient to the plot in axes with handle AX.
%
% ADDGRADIENT(AX,TOPCOLOR,BOTTOMCOLOR) adds a gradient ranging from the
% specified colors, with TOPCOLOR at the top of the plot and BOTTOMCOLOR at
% the bottom of the plot.  TOPCOLOR and BOTTOMCOLOR must be specified as
% RGB triplets, e.g. [R G B], where R, G, and B range from 0 to 1 to
% indicate the intensity of Red, Green, and Blue in the specified color
%
% P = ADDGRADIENT(...)  returns handle to the patch used to draw the
% gradient.  This is useful if you want to further modify the gradient,
% such as by setting the transparency
%
% It is recommended that you add the gradient after setting the final axis
% limits, since the gradient is not redrawn when axis limits change.
%
% Ex
%    clf
%    plot(10*rand(1,100));
%    addgradient
%
%
%    clf
%    ax1 = subplot(211)
%    plot(magic(3))
%    ax2 = subplot(212)
%    plot(10*rand(1,100));
%    topcolor = [1 0 0];    % red
%    bottomcolor = [0 1 0]; % green
%    addgradient(ax1)       % Default gray gradient to top plot
%    p = addgradient(ax2,topcolor,bottomcolor);  % Red-green gradient to bottom plot
%    set(p,'FaceAlpha',.3)  % Make transparent

% Michelle Hirsch
% mhirsch@mathworks.com
% Copyright 2010-2014 The MathWorks, Inc

if nargin==0 || isempty(ax)
    ax = gca;
end

if nargin<2
    topcolor = [.95 .95 .95];
    bottomcolor = [.75 .75 .75];
end


lim = axis(ax);
xdata = [lim(1) lim(2) lim(2) lim(1)];
ydata = [lim(3) lim(3) lim(4) lim(4)];
cdata(1,1,:) = bottomcolor;
cdata(1,2,:) = bottomcolor;
cdata(1,3,:) = topcolor;
cdata(1,4,:) = topcolor;

p =patch(xdata,ydata,'k','Parent',ax);

set(p,'CData',cdata, ...
    'FaceColor','interp', ...
    'EdgeColor','none');

uistack(p,'bottom') % Put gradient underneath everything else

if nargout
    varargout{1} = p;
end

set(gca,'Layer','top')