function [ I_res ] = STB_getResidualImage( STB_params, cameraSystem, positionsConverged, intensities, I_rec )
% This function computes the residual Image. This is done by taking the
% original image and subtracting the projections of all given (converged)
% particle positions. The residual image can be used to find new particles
% using 3D-correspondence search.
P = cameraSystem.getProjectionMatrices;

window2d_full.xmin = 1;
window2d_full.xmax = cameraSystem.cameraCalibrations(1).camera.width;
window2d_full.ymin = 1;
window2d_full.ymax = cameraSystem.cameraCalibrations(1).camera.height;


for camNo = 1:cameraSystem.nCameras
    
    
    I_tmp  = STB_projectImage(camNo, STB_params, positionsConverged, cameraSystem, window2d_full, intensities(:,camNo) );
    
    % prepare projected image and convert
    I_tmp(I_tmp>1) = 1;
    I_tmp = uint8(I_tmp.*255);
    I_res{camNo} = imsubtract(I_rec{camNo},I_tmp);
    
end

