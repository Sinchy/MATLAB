function [DLT, Axis, camLabels, camPos, camDir, camUp] = plotCameraSetup(focalLength, pixelSize, imageSize, observationDistance, baselineDistance, numCams, transformationMatrix, frustumDistance, cameraColors, bShareCameraOrientation)

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



[K] = cameraIntrinsics(focalLength, pixelSize, imageSize);
[camPos, camDir, camUp, camP, DLT, camR, maxTheta] = constructCameraPlacement(observationDistance, baselineDistance, numCams, K, imageSize, bShareCameraOrientation);
camPos = geometry_algorithm.transformPoints(camPos, transformationMatrix);
camDir = geometry_algorithm.transformPoints(camDir, transformationMatrix);
camUp  = geometry_algorithm.transformPoints(camUp,  transformationMatrix);

for c=1:numCams
    camR{c} =  geometry_algorithm.constructOrthonormalCoordinateFrame(camDir(c,:), camUp(c,:), false);
end

figure;
set(gcf, 'color', 'w');
set(gca, 'fontsize', fontSize-1);

for c=1:numCams
    plot_tools.plotCamera(camPos(c,:), camR{c}', focalLength, imageSize, pixelSize, frustumDistance, true, cameraColors(c,:), true, bPlotPrincipalAxis);
    camLabels(c) = text(camPos(c,1)-camDir(c,1)*textOffset*observationDistance, camPos(c,2)-camDir(c,2)*textOffset*observationDistance, camPos(c,3)-camDir(c,3)*textOffset*observationDistance, sprintf('C_%d', c), 'fontsize', fontSize, 'fontweight', 'bold', 'horizontalalignment', 'center', 'verticalAlignment', 'top', 'color', cameraColors(c,:));
    textExtents(c,:) = get(camLabels(c), 'Extent');
end
axis equal
axis tight
view([30,30]);
Axis = axis;
textSize = max([textExtents(:,3); textExtents(:,4)])*1.5;
Axis=Axis+[-1 1 -1 1 -1 1]*(textSize+observationDistance*textOffset);
axlen = Axis(4)-Axis(3);
axis(Axis);
view([0 90]);

fixationPoint = [0 0 0];
fixationPoint = geometry_algorithm.transformPoints(fixationPoint, transformationMatrix);
plot_util.plotColumns(fixationPoint, 'ko', 'markerfacecolor', 'k');
camLabels(c+1) = text(fixationPoint(1)+textOffset*observationDistance, fixationPoint(2), fixationPoint(3), 'F', 'fontsize', fontSize, 'fontweight', 'bold', 'horizontalalignment', 'left','verticalAlignment', 'middle');

[x y z] = plot_util.axislabels('X Position (m)', 'Y Position (m)', 'Z Position (m)');
set(x, 'fontsize', fontSize, 'fontweight', 'bold');
set(y, 'fontsize', fontSize, 'fontweight', 'bold');
set(z, 'fontsize', fontSize, 'fontweight', 'bold');

