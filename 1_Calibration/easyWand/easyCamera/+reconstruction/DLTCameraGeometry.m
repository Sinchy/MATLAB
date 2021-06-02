function [camPos camDir planeCoefs Z camUp camR] = DLTCameraGeometry(coefs)
% function [camPos camDir planeCoefs Z] = DLTCameraGeometry(coefs)
% Inputs: coefs - the 11 DLT coefficients for the camera in question
% Outputs:
%    camPos - positions of the cameras (as computed by DLTcameraPosition)
%    camDir - look direction of the cameras (NOT the look at point)
%    planeCoefs - coefficients ([A B C D]) of the plane equation to check
%                 if points are in front of or behind the cameras)
%    Z - distance from camera to image plane (from DLTcameraPosition)
import reconstruction.*;

  [xyz,T,ypr,Uo,Vo,Z] = DLTcameraPosition(coefs);
  camPos = xyz';
  
  camDir = (T(1:3,1:3)'*[0 0 -1]')';
  camUp = (T(1:3,1:3)'*[0 1 0]')';
  camR = geometry_algorithm.constructOrthonormalCoordinateFrame(camDir, camUp, false);
  
  abc = camDir;
  d = -dot(xyz,abc);
  planeCoefs = [abc d];
end
