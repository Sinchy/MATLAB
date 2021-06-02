function plotCamera(t, R, f, res, pixSize, dist, bZUp, color, bPlotProjectionPlane, bPlotPrincipalAxis)
% function plotCamera(t, R, f, res, pixSize, dist, bZUp, color)
% Plot a camera graphic representation
%
% @param t - the position of the camera
%
% @param R - the rotation matrix that rotates the world into the camera
%
% @param f - the focal length (meters)
%
% @param res - the number of pixels [width height]
%
% @param pixSize - physical size of pixels (meters)
%
% @param dist - how far out to plot the camera's projection plane
%
% @param bZUp - whether or not to make the Z axis go up (as opposed to being the optical axis of the camera)
% (yes, if plotted in the context of a scene. No if plotted on it's own)
%
% @param color - 3 element color vector
%

import plot_util.plotColumns;
import geometry_algorithm.transformPoints;

if ~exist('bPlotProjectionPlane', 'var') || isempty(bPlotProjectionPlane)
    bPlotProjectionPlane=true;
end
if ~exist('bPlotPrincipalAxis', 'var') || isempty(bPlotPrincipalAxis)
    bPlotPrincipalAxis=true;
end


principleAxis = [0 0 dist; 0 0 0; 0 0 -f];

sensorHalfSize = pixSize*res/2;
projectionPlane = [sensorHalfSize(1) sensorHalfSize(2) -f; ...
    sensorHalfSize(1) -sensorHalfSize(2) -f; ...
    -sensorHalfSize(1) -sensorHalfSize(2) -f; ...
    -sensorHalfSize(1) sensorHalfSize(2) -f;];

viewAngle = atan2(sensorHalfSize, f);
fieldOfView = util.normalizeVectors(projectionPlane);
fieldOfView = fieldOfView .* repmat( dist ./ util.rowdot(repmat([0 0 1], 4,1), fieldOfView), 1, 3);

T = R;
T(4,4) = 1;

if exist('bZUp', 'var') && ~isempty(bZUp) && bZUp
    RR = geometry_algorithm.constructOrthonormalCoordinateFrame([0 0 1], [0 1 0]);
    T = T*RR;
end

T(1:3,4) = t(:);


projectionPlane = transformPoints(projectionPlane, T);
fieldOfView = transformPoints(fieldOfView,T);
principleAxis = transformPoints(principleAxis, T);

if ~exist('color', 'var') || isempty(color)
    color = [1 0 0];
end

hold on;
plotColumns(projectionPlane([1:4 1],:), '-', 'color', color);
for i=1:4
    plotColumns([projectionPlane(i,:); fieldOfView(i,:)], '-', 'color', color, 'linewidth', 3);
end

if bPlotProjectionPlane
    plotColumns(fieldOfView([1:4 1],:), '-', 'color', color);
end
if bPlotPrincipalAxis
    plotColumns(principleAxis, '-', 'color', color);
    plotColumns(principleAxis(2,:), 'o', 'color', color);
end

end
