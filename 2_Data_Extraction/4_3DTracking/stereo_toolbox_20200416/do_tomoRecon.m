%% preferences
params.nCameras   = cameraSystem.nCameras;
params.imagePaths = './cam%d/image_%05d.png';
arraySize.x = [-2 2];
arraySize.y = [-2 2];
arraySize.z = [-4 4];

frameRange = 31;
initialIntensity = 1;   % 1 for usual MART
voxelScale = 2;         % 1 means voxel-size ~ pixel-size in image
maxIter = 5;            % no of MART iterations
neiPixels = 0;          % neighboring pixels around "highest peak" projection of voxel

%% initialization
[basisFunction, X, Y, Z]  = tomo_generateVoxelArray(cameraSystem, arraySize, voxelScale, initialIntensity);

wij = tomo_getWeighting(basisFunction, X, Y, Z, cameraSystem, neiPixels);

%% process frames
%pref = parpool(4);

for frame = frameRange(1):frameRange(end)
    I_rec = STB_loadCameraImages( params, frame);
    fprintf(1,'tomoRecon:: Processing MART-Iter '); 
    for nIter = 1:maxIter
        fprintf(1,'%02d/%02d: ',nIter,maxIter); 
        basisFunction = tomo_MART(I_rec, basisFunction, wij, p_out, 1);
        fprintf(1,'\b\b\b\b\b\b\b');
    end
    fprintf(1,' [ done ]\n');
end
%delete(pref)

