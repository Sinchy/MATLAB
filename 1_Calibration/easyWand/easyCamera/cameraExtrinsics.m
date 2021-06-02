function [cameraMatrix cameraOrientation] = cameraExtrinsics(cameraPosition, cameraLookAt, K)
% function [cameraMatrix cameraOrientation] = cameraExtrinsics(cameraPosition, cameraLookAt, intrinsics)
% Hartley and Zisserman chapter 6
% @param: cameraPosition - the location of the camera in the world (Z up)
%
% @param: cameraLookAt - the world point the camera is looking at (Z up)
%                        (alternative usage: the pre-calculated rotation matix)
%
% @param: intrinsics - (optional) the precomputed camera intrinsics matrix
%
% @return: cameraMatrix - the camera matrix to go from world coordinates to
%                         image coordinates of camera placed at cameraPosition with
%                         orientation looking at the look at point.
%
% @return cameraOrientation - just the rotation matrix, to transform the
%                             world INTO the camera's coordinate frame (not camera to world)
%

if ~exist('K', 'var') || isempty(K)
    K = eye(3);
end

if numel(cameraLookAt) == 3
    lookVector = -[cameraLookAt(:) - cameraPosition(:)]';
     lookVector = lookVector / norm(lookVector);
     upVector = [0 1 0];
     sideVector = cross(upVector, lookVector);
     sideVector = sideVector / norm(sideVector);
     cameraOrientation = ([sideVector; upVector; lookVector]);
        
elseif numel(cameraLookAt)==9
    cameraOrientation=cameraLookAt;
end

cameraPosition = cameraPosition(:);
cameraMatrix = K*cameraOrientation*[eye(3) -cameraPosition];

end