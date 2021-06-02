function [ parameterStructure ] = camSysToMATLAB( cameraSystem )
% This function converts the cameraSystem (obtained by the calibration
% Toolbox) to a parameter structure that is used by the machine vision
% toolbox


for k = 1:cameraSystem.nCameras
    camera = cameraSystem.cameraCalibrations(k).camera;
   parameterStructure(k).IntrinsicMatrix = [ camera.gamma1 , 0 , 0 ; 0 camera.gamma2 , 0 ; camera.u0 , camera.v0, 1 ];
   parameterStructure(k).RadialDistortion = [ camera.k1 , camera.k2 ];
   parameterStructure(k).TangentialDistortion = [ camera.p1 , camera.p2 ];
   parameterStructure(k).ImageSize = [ camera.width , camera.height ];
  
   parameterStructure(k).RotationVectors = [cameraSystem.cameraCalibrations(k).photosInfo.rvec]';
   parameterStructure(k).TranslationVectors = [cameraSystem.cameraCalibrations(k).photosInfo.tvec]';
end




end

