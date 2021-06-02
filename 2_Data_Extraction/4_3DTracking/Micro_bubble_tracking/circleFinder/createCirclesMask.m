function mask = createCirclesMask(sz,centers,radii)
% mask = createCirclesMask(sz,centers,radii)
%
% Create a binary mask from circle centers and radii. This approach uses a
% pre-calculated bwdist matrix, from which "stamps" are created, and with
% which the initial zeros mask is modified. It's very fast.
%
% SYNTAX:
% mask = createCirclesMask([xDim,yDim],centers,radii);
% OR
% mask = createCirclesMask(I,centers,radii);
%
% INPUTS:
% [XDIM, YDIM]   A 1x2 vector indicating the size of the desired
%                mask, as returned by [xDim,yDim,~] = size(img);
%
% I              As an alternate to specifying the size of the mask
%                (as above), you may specify an input image, I,  from which
%                size metrics are to be determined.
%
% CENTERS        An m x 2 vector of [x, y] coordinates of circle centers
%
% RADII          An m x 1 vector of circle radii
%
% OUTPUTS:
% MASK           A logical mask of size [xDim,yDim], true where the circles
%                are indicated, false elsewhere.
%
%%% EXAMPLE:
%   img = imread('coins.png');
%   [centers,radii] = imfindcircles(img,[20 30],...
%      'Sensitivity',0.8500,...
%      'EdgeThreshold',0.30,...
%      'Method','PhaseCode',...
%      'ObjectPolarity','Bright');
%   figure
%   subplot(1,2,1);
%   imshow(img)
%   % Create a mask with the same number or rows and columns as img:
%   mask = createCirclesMask(img,centers,radii);
%   % OR create a mask with N rows, M cols:
%   % N = 100; M = 200; mask = createCirclesMask([N,M],centers,radii);
%   subplot(1,2,2);
%   imshow(mask)
%
% See Also: imfindcircles, viscircles, CircleFinder
%
% Brett Shoelson, PhD; and Steve Eddins, PhD;
% 9/22/2014
% Comments, suggestions welcome: brett.shoelson@mathworks.com

% Copyright 2014 The MathWorks, Inc.
% MODIFICATIONS:
% 1/16/2014: Returns an empty mask (instead of an error) if centers/radii
% are empty.

narginchk(3,3)
if numel(sz) == 2
	% SIZE specified
	xDim = sz(1);
	yDim = sz(2);
else
	% IMAGE specified
	[xDim,yDim,~] = size(sz);
end
mask = false(xDim,yDim);
if isempty(radii)
	return
end
Rmax = ceil(max(radii));
bw = false(2*Rmax+1);
bw(Rmax+1,Rmax+1) = 1;
D = bwdist(bw);

centers = round(centers);
xc = centers(:,1);
yc = centers(:,2);
Rim = ceil(radii);

for k = 1:numel(radii)
	% Create "stamp"
	rLo = Rmax-Rim(k);
	rHi = Rmax+Rim(k);
	circle_k = D(1 + (rLo:rHi),1 + (rLo:rHi)) <= radii(k);
	%Compute subscripts for stamp location
	r1 = max(1,yc(k) - Rim(k));
	r2 = min(yDim,yc(k) + Rim(k));
	c1 = max(1,xc(k) - Rim(k));
	c2 = min(yDim,xc(k) + Rim(k));
	targetSize = [r2-r1+1 c2-c1+1];
	if any(targetSize~=size(circle_k))
		% TRIM REQUIRED; Trim circle stamps that overlap image border:
		offsets = [yc(k)-Rim(k),yc(k)+Rim(k),xc(k)-Rim(k),xc(k)+Rim(k)];
		trimAmounts = [r1-offsets(1) offsets(2)-r2 c1-offsets(3) offsets(4)-c2];%[top bottom left right]
		circle_k = circle_k(1+trimAmounts(1):end-trimAmounts(2),1+trimAmounts(3):end-trimAmounts(4));
	end
	if ~isempty(circle_k) && all([r1>0,r2<=xDim,c1>0,c2<=yDim])
		mask(r1:r2,c1:c2) = mask(r1:r2,c1:c2) | circle_k;
	end
end
