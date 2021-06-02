function [camPos, camDir, camUp, camP, dlt, camR, maxTheta] = constructCameraPlacement(observationDistance, baselineDistance, numCams, K, imageSize, bShareCameraOrientation)
% function [camPos, camDir, camUp, camP, dlt, camR, maxTheta] = constructCameraPlacement(observationDistance, baselineDistance, numCams, K)
%
% Construct a camera placement with cameras on a circle, looking at a
% common equidistant fixation point
%
% @param: observationDistance - the distance to the common fixation point
%
% @param baselineDistance - the distance between the farthest left and
%                           right cameras
%
% @param: numCams - number of cameras to place
%
% @param: K (optional) - intrinsic parameter matrix
%
% @param: imageSize (optional)
%

if ~exist('K', 'var')
    K = [];
end

if ~exist('bShareCameraOrientation', 'var') || isempty(bShareCameraOrientation)
    bShareCameraOrientation = false;
end


cameraLookAt = [0 0 0];
dummyxyz = sampleSpace(1000, [-observationDistance observationDistance], [-observationDistance observationDistance], [-observationDistance observationDistance]);

maxTheta = 0;
if baselineDistance > observationDistance*2
    maxTheta = pi/2;
    baselineDistance = baselineDistance - observationDistance*2;
end
maxTheta = maxTheta + asin(baselineDistance/2/observationDistance);
dTheta = maxTheta*2/(numCams-1);
camTheta = -maxTheta:dTheta:maxTheta;

camPos = zeros(numCams, 3);
camPos(:,1) = observationDistance * sin(camTheta);
camPos(:,3) = -observationDistance * cos(camTheta);

if ~bShareCameraOrientation
    camDir = util.normalizeVectors(-camPos);
else
    camDir = repmat([0 0 1], numCams,1);
end

camUp = repmat([0 1 0], numCams,1);

camR = cell(numCams,1);
camP = cell(numCams,1);

dlt = zeros(11,numCams);
for c=1:numCams
    if ~bShareCameraOrientation
        [camP{c} camR{c}] = cameraExtrinsics(camPos(c,:), cameraLookAt, K);
    else
        [camP{c} camR{c}] = cameraExtrinsics(camPos(c,:), camPos(c,:)+[0 0 observationDistance], K);
    end
    [uv ptIdx] = cameraProjectPoints(dummyxyz, camP{c}, imageSize);
    dlt(:,c) = reconstruction.dlt_computeCoefficients(dummyxyz(ptIdx,:), uv);
end

end