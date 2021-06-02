function [K fieldOfView sensorSize principalPoint] = cameraIntrinsics(focalLength, pixelSize, imageResolution)
%function [K fieldOfView sensorSize principalPoint] = cameraIntrinsics(focalLength, pixelSize, imageResolution)
%
% assumes rectilinear, square pixels
%
% @param: focalLength - the focal length of the camera (units: meters)
% 
% @param: pixelSize - the physical size of the camera pixels (units: meters)
%
% @param: imageResolution - the number of pixels in the image. two element vector for [width height]
%
% @return: K - intrinsic parameter matrix to go from world coordinates to
% image coordinates (assuming camera at origin and orientation the identity)
%
% @return: fieldOfView - the field of view of the camera (degrees) from
% left edge to right edge
%
% @return: sensorSize - the size of the sensor
%

sensorSize = pixelSize*imageResolution;         
fieldOfView = atan2(sensorSize/2, [focalLength focalLength])*2 *180/pi;       


a = focalLength/pixelSize;             
principalPoint = imageResolution/2;

K = [a 0 principalPoint(1); 0 a principalPoint(2); 0 0 1];

end
