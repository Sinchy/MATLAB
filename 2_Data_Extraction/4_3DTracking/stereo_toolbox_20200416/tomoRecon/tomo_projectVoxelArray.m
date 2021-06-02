function [ ] = tomo_projectVoxelArray(arraySize, cameraSystem)
% projects the outer edges of the basisFunction voxels onto artifitial
% camera images. Can be used to fine-tune (maximize) the reconstruction
% volume.

[X, Y, Z] = ndgrid(arraySize.x, arraySize.y, arraySize.z);
corners = [X(:), Y(:), Z(:)];

pos2d = STB_get2DPositions(corners, cameraSystem);

for k = 1:cameraSystem.nCameras
    
    I = zeros(cameraSystem.cameraCalibrations(k).camera.height, cameraSystem.cameraCalibrations(k).camera.width);
    figure;
    imshow(I);
    hold on;
    plot(pos2d{k}(:,1), pos2d{k}(:,2), 'r+');
    pause(0.1);
end


end

