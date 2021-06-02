function [ basisFunction, X, Y,Z ] = tomo_generateVoxelArray(cameraSystem, size, voxelSizeScale, initIntensity)
% this function generates an initial voxel array to be used with
% tomographic reconstruction.
%
% The basisFunction is assumed to be the locations of the voxel-centres
% (and not the edges).
% According to G.E. Elsinga et al., Exp Fluids (2006) 41:933-947


% first step: check the size of a pixel projected to 3d (which should be
% the voxel-size in the end:

% project two (0.1mm shifted) points onto the sensor to check
% magnification:
fprintf('tomoRecon:: Generating intensity field...');

P = cameraSystem.getProjectionMatrices;

for k = 1:cameraSystem.nCameras
    x1 = P(k).projectionMatrix*[0 0 0 1]'; x1 = x1./x1(3);
    x2 = P(k).projectionMatrix*[1 0 0 1]'; x2 = x2./x2(3);
    y1 = P(k).projectionMatrix*[0 0 0 1]'; y1 = y1./y1(3);
    y2 = P(k).projectionMatrix*[0 1 0 1]'; y2 = y2./y2(3);
    z1 = P(k).projectionMatrix*[0 0 0 1]';  z1 = z1./z1(3);
    z2 = P(k).projectionMatrix*[0 0 1 1]'; z2 = z2./z2(3);
    
    dist_x(k) = distance2d(x1',x2');
    dist_y(k) = distance2d(y1',y2');
    dist_z(k) = distance2d(z1',z2');
    
end
voxelSize = max( [ dist_x(:)' dist_y(:)' dist_z(:)' ] ); %px for 1 mm

% thus, 1px sensor equals:
voxelSize = voxelSizeScale/voxelSize; %in mm


voxelCentres_x = size.x(1):voxelSize:size.x(end);
voxelCentres_y = size.y(1):voxelSize:size.y(end);
voxelCentres_z = size.z(1):voxelSize:size.z(end);

[X,Y,Z] = ndgrid(voxelCentres_x, voxelCentres_y, voxelCentres_z);

basisFunction = initIntensity.*ones([length(voxelCentres_x),length(voxelCentres_y),length(voxelCentres_z)],'single') ;

X = single(X);
Y = single(Y);
Z = single(Z);

fprintf('[ done ]\n');
end

