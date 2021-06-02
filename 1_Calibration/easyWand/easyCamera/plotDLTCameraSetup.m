function [DLT, Axis, camLabels, camPos, camDir, camUp] = plotDLTCameraSetup(DLT, focalLength, pixelSize, imageSize, transformationMatrix, frustumDistance, cameraColors)

fontSize = 12;
bPlotPrincipalAxis = false;
textOffset = .05;

if ~exist('cameraColors', 'var') || isempty(cameraColors)
    cameraColors = plot_util.DianesColormaps('hsv', ceil(numCams*1.25), .9, .8);
    cameraColors = cameraColors(end:-1:end-numCams+1,:);
end

if ~exist('transformationMatrix', 'var') || isempty(transformationMatrix)
    transformationMatrix = eye(4);
end

if ~exist('bShareCameraOrientation', 'var')
    bShareCameraOrientation = false;
end

figure;
set(gcf, 'color', 'w');
set(gca, 'fontsize', fontSize-1);
numCams = size(DLT,2);

for c=1:numCams
    [camPos(c,:) camDir(c,:) planeCoefs(c,:) Z(c) camUp(c,:)] = reconstruction.DLTCameraGeometry(DLT(:,c));
    camR{c} = geometry_algorithm.constructOrthonormalCoordinateFrame(camDir(c,:), camUp(c,:));
    plot_tools.plotCamera(camPos(c,:), camR{c}', focalLength, imageSize, pixelSize, frustumDistance, true, cameraColors(c,:), true, bPlotPrincipalAxis);
    camLabels(c) = text(camPos(c,1)-camDir(c,1)*textOffset*frustumDistance, camPos(c,2)-camDir(c,2)*textOffset*frustumDistance, camPos(c,3)-camDir(c,3)*textOffset*frustumDistance, sprintf('C_%d', c), 'fontsize', fontSize, 'fontweight', 'bold', 'horizontalalignment', 'center', 'verticalAlignment', 'middle', 'color', cameraColors(c,:));
    textExtents(c,:) = get(camLabels(c), 'Extent');
end
axis equal
axis tight
view([30,30]);
Axis = axis;
textSize = max([textExtents(:,3); textExtents(:,4)])*1.5;
Axis=Axis+[-1 1 -1 1 -1 1]*(textSize+frustumDistance*textOffset);
axis(Axis);
view([0 90]);

[x y z] = plot_util.axislabels('X Position (m)', 'Y Position (m)', 'Z Position (m)');
set(x, 'fontsize', fontSize, 'fontweight', 'bold');
set(y, 'fontsize', fontSize, 'fontweight', 'bold');
set(z, 'fontsize', fontSize, 'fontweight', 'bold');

end