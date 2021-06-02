function [ pos3d ] = tomo_STBdetection(cameraSystem, frameNo)
%

params.nCameras   = cameraSystem.nCameras;
params.imagePaths = './cam%d/image_%05d.png';
arraySize.x = [-5 5];
arraySize.y = [0 7.5];
arraySize.z = [-2 1];

initialIntensity = 1;   % 1 for usual MART
voxelScale = 2;         % 1 means voxel-size ~ pixel-size in image
maxIter = 4;            % no of MART iterations
neiPixels = 0;          % neighboring pixels around "highest peak" projection of voxel


[basisFunction, X, Y, Z]  = tomo_generateVoxelArray(cameraSystem, arraySize, voxelScale, initialIntensity);
I_rec = STB_loadCameraImages( params, frameNo);

for k = 1:4
    I_rec{k}(I_rec{k}<4) = 0;
end

fprintf(1,'tomoRecon:: Processing MART-Iter ');
for nIter = 1:maxIter
    fprintf(1,'%02d/%02d: ',nIter,maxIter);
    basisFunction = tomo_MART(I_rec, basisFunction, 1);
    fprintf(1,'\b\b\b\b\b\b\b');
end
fprintf(1,' [ done ]\n');

pos3d = tomo_getParticlePositions(basisFunction, X, Y, Z, 0.04, 0.06);

end

