%% loading the necessary files
function [trackCluster, trackData, trackFit] = ...
    From2Dto3DTracks_multiplecams(tr_numbers, trackCluster, trackData, trackFit)
    if nargin<2
      trackCluster = cell(1,1); trackData = cell(1,1); trackFit = cell(1,1);
    end
%%   
addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\';
addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\splinefit\';

load('VSC_calib_04.12.18.mat')
load('all2Dtracks.mat');
load('all_camCombinations_2DTracksTriangulations.mat');

% Images with tracks
% 
dirr = ['C:\Users\aks5577\Desktop\cam_config_of_04.04.18\ProcessedImages\04.12.18\Bubbles3\noBubbles_200frLaVImgProcess2\'];
% dirr = 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\straight_line_track\';
% cam_dir = {dirr, dirr, dirr, dirr};
cam_dir = {[dirr 'cam1_corrected\'], [dirr 'cam2_corrected\'], [dirr 'cam3\'], [dirr 'cam4\'], [dirr 'cam5\'], [dirr 'cam6\']}; 


tr_images = zeros(1024,1024,6);
for i = 1:4
    for frame = 1:200
        img = imread([cam_dir{i} 'cam' num2str(i) 'frame' num2str(frame,'%04.0f') '.tif']);
        tr_images(:,:,i) = max(tr_images(:,:,i),double(img));
    end
end


%% inputs
globalMaxVel = 1; % mm / s
%% making a list of trackIDs (combined from all cams) sorted by their 2D track length
[a1,b1]=hist(tr1(:,1),unique(tr1(:,1)));a1 = a1';

[a2,b2]=hist(tr2(:,1),unique(tr2(:,1)));a2 = a2';

[a3,b3]=hist(tr3(:,1),unique(tr3(:,1)));a3 = a3';

[a4,b4]=hist(tr4(:,1),unique(tr4(:,1)));a4 = a4';


for cam = 1:4
    long_trackIDs =[0 0 0];
    for i = 200:-1:1
        eval(['a = a' num2str(cam) '; b = b' num2str(cam) ';']);
        ind = find(a == i);
        long_trackIDs = [long_trackIDs; a(ind) b(ind) repmat(cam, [numel(ind),1])];
    end
    long_trackIDs(1,:) = [];
    eval(['long_trackIDs_' num2str(cam) ' = long_trackIDs;']);
end


long_trackIDs = [long_trackIDs_1; long_trackIDs_2; long_trackIDs_3; long_trackIDs_4];
long_trackIDs = sortrows(long_trackIDs,1,'descend');

%%

% filenames for 2D tracks on cams 1 to 4
order_filename(1,:) = [1234, 123, 124, 134];
order_filename(2,:) = [1234, 123, 124, 234];
order_filename(3,:) = [1234, 123, 134, 234];
order_filename(4,:) = [1234, 124, 134, 234];

%% combining the triangulation points from 2D tracks to get the best 3D track fit

% tracks3D = cell(1,1);
good_trk = [6 8 10 14 19 25 28 34 35 37 44 48 50];
double_trk = [9 12 15 21 29 36 38 47];
tic

for trk =  tr_numbers %200000 %good_trk % double_trk
    track3D_isolated = zeros(1,8);
    cam = long_trackIDs(trk,3);

    for i = 1:4
        for frame = 5:196
            filename = order_filename(cam,:);
            eval(['fr = cam_' num2str(filename(i)) '{' num2str(frame) ',1};']);            
            ind = find(fr(:,cam + 3) == long_trackIDs(trk,2));
            track3D_isolated = [track3D_isolated;[fr(ind,1:7) repmat(frame,[numel(ind), 1])]];
            siz(frame-4) = sum(ind);
            clear fr
        end
    end

    track3D_isolated(1,:) = [];
%     figure(1);
%     subplot(1,2,1)
%     robustSpline_3DTrackFit(track3D_isolated, tr_images, tr1, tr2, tr3, tr4,camParaCalib, 0, cam);
    figure(1); %hold off
%     subplot(1,2,2)
    [trackCluster{trk,1}, trackData{trk,1}, trackFit{trk,1}] = ...
        robustSpline_3DTrackFit(track3D_isolated, tr_images, tr1, tr2, tr3, tr4,camParaCalib, 8, cam, 0, globalMaxVel);
    M(trk) = getframe;
    
end

toc
end