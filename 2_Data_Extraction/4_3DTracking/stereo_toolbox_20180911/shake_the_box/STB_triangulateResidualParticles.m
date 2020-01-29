function [ predictions ] = STB_triangulateResidualParticles( I, cameraSystem, STB_params, frameNo)
% This function can be used to read the triangulation data, that has been
% writen to disc by the nCam3dMultiset or fourCam3dMultiset function.

predictions = []; % if clustering fails (no particle or whatever...)

% find 2d positions in residual images
% prepare "settings"-structure as needed by detect2d:
settings.nCams = cameraSystem.nCameras;
settings.output2Dcoords = STB_params.detect2d.output2dFilemask;
settings.im_range = frameNo;

for k = 1:settings.nCams
    settings.parameters2D(k).doSobel = 0;
    settings.parameters2D(k).optionsNoise = STB_params.detect2d.lNoise(k);
    settings.parameters2D(k).optionsObject = STB_params.detect2d.lObject(k);
    settings.parameters2D(k).optionsThreshold = STB_params.detect2d.threshold(k);
    settings.parameters2D(k).ROI.X = [];
end

detect2d(settings, 0, I);
try
positions = dlmread(sprintf(settings.output2Dcoords,frameNo));
end
% figure;
% imshow(I{1});
% hold on;
% plot(positions(:,1), positions(:,2), 'r+');
% pause(0.1);
%
% figure;
% imshow(I{2});
% hold on;
% plot(positions(:,3), positions(:,4), 'r+');
% pause(0.1);
%
% figure;
% imshow(I{3});
% hold on;
% plot(positions(:,5), positions(:,6), 'r+');
% pause(0.1);
%
% figure;
% imshow(I{4});
% hold on;
% plot(positions(:,7), positions(:,8), 'r+');
% pause(0.1);


%fprintf(1,'\n');
% give the algorithm the current frame no.
% 3D-triangulation with different sets
STB_params.im_range = frameNo;
STB_params.triangulation.output3Dcoords = STB_params.output3Dcoords ;
STB_params = nCam3dMultiset( STB_params, cameraSystem, 1, 0 );
%fprintf(1,'\n');
% cluster data (if existing)
try
    [predictions, ~] = triangulationToCluster(STB_params, frameNo, STB_params.triangulation.visInNumofPerms, STB_params.triangulation.clusterSizeApprox, 0, 1);
catch
    
end

end

