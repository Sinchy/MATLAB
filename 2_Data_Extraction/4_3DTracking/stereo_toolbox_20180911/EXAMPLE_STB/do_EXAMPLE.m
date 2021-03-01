%% load the dataset
load('exampleDataset.mat');

%% generate the generic images from the particle data
frame_range =  31:141;
STB_params.cam1_filename = './cam1/image_%05d.png';
STB_params.cam2_filename = './cam2/image_%05d.png';
STB_params.cam3_filename = './cam3/image_%05d.png';
STB_params.cam4_filename = './cam4/image_%05d.png';
STB_params.evalWindowSize   = 4; %px
STB_params.projection.width = 4;  %px
createSimuImages;

%% get the parameters for 2d detection, needed by triangulation algorithm
%This asks you for 2d-detection settings. Use threshold 10 for the example
%images (keep defaults o other settings). Note that not all particles (out of 400) can be individually
%resolved due to occlusion. But don't worry, as STB will take care about
%this issue.
do_detection2d;  
%% Shake-the-Box
% execute the actual STB reconstruction. Look into do_shakeTheBox for
% adjustments to your specific task. For this example, the initial track ar
% already included. For a real measurement you will have to get them using
% e.g. the triangulation+tracking method from the "EXAMPLE_SPT". 
do_shakeTheBox;


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

