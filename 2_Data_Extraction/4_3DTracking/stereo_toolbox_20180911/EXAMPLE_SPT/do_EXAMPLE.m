%% load the dataset
load('exampleDataset.mat');

%% generate the generic images from the particle data
frame_range =  31:100;
cam1_filename = './cam1/image_%05d.png';
cam2_filename = './cam2/image_%05d.png';
cam3_filename = './cam3/image_%05d.png';
cam4_filename = './cam4/image_%05d.png';
SPT_params.evalWindowSize   = 4; %px
SPT_params.projection.width = 4;  %px
createSimuImages;

%% get the parameters for 2d detection, needed by triangulation algorithm
%This asks you for 2d-detection settings. Use threshold 10 for the example
%images (keep defaults of other settings). Note that not all particles (out of 400) can be individually
%resolved due to occlusion.
do_detection2d;  

%% multiset-triangulation and clustering
do_multisetTriangulation;

%% tracking
do_tracking;

%% show the results
STB_plotPrediction(tracks);
axis equal;
% overlay with dots marking the ground truth data
for k = 1:length(groundTruthData)
    hold on;
    plot3(groundTruthData(k).position(1:numel(frame_range),1),...
          groundTruthData(k).position(1:numel(frame_range),2),...
          groundTruthData(k).position(1:numel(frame_range),3),'.c');
end

