%heavily modified version. Specifically designed to integrate in the
% toolbox's GUI
%
%Christian Wengert
%Computer Vision Laboratory
%ETH Zurich
%Sternwartstrasse 7
%CH-8092 Zurich
%www.vision.ee.ethz.ch/cwengert
%wengert@vision.ee.ethz.ch
dX = 1;
dY = 1;


%Extract the grid points
[success, stats, cnt, id0, id1, searchPoints] = gridextractor_Micha(im, 1, minArea, maxArea, minEllipticity, maxEllipticity, minSolidity, min_BarSize, 0, markerDiameter,barMode);

% fit the grid
if(success && cnt==2 && length(stats)>0)
    %Fit the grid
    [success, x, X, searchPoints, err] = fitgrid(stats, searchPoints, id0, id1, dX, dY, 1);
else
    disp(['autocalibrate:: Not enough image information in this image. Set it to inactive.']);
end



