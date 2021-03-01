% in V2, I interchange the for loops of 2 tracks and file names. This
% increases the speed of the code as I only need to load the 

%% loading the necessary files

addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\';
addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\splinefit\';

load('VSC_calib_04.12.18.mat')
load('all2Dtracks.mat');
load('all_camCombinations_2DTracksTriangulations.mat');

% Images with tracks
% 
dirr = ['C:\Users\aks5577\Desktop\cam_config_of_04.04.18\ProcessedImages\04.12.18\Bubbles3\noBubbles_200frLaVImgProcess\'];
% dirr = 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\straight_line_track\';
% cam_dir = {dirr, dirr, dirr, dirr};
cam_dir = {[dirr 'cam1_corrected\'], [dirr 'cam2_corrected\'], [dirr 'cam3\'], [dirr 'cam4\'], [dirr 'cam5\'], [dirr 'cam6\']}; 


tr_images = zeros(1024,1024,6);
for i = 1:4
    for frame = 1:20
        img = imread([cam_dir{i} 'cam' num2str(i) 'frame' num2str(frame,'%04.0f') '.tif']);
        tr_images(:,:,i) = max(tr_images(:,:,i),double(img));
    end
end

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
%% load files for 2D tracks on cams 1 to 4

addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\';
addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\splinefit\';
% load_filename = {'pos3D_2D0.05_3D0.05_123_200frames_withShortTracks.mat', 'pos3D_2D0.05_3D0.05_124_200frames_withShortTracks.mat'...
%     'pos3D_2D0.05_3D0.05_134_200frames_withShortTracks.mat', 'pos3D_2D0.05_3D0.05_1234_200frames_withShortTracks.mat'};

% load files for 2D tracks on cams 1 to 4
load_filename1 = {'allcams_3D0.1_2D0.1_new.mat', '123cams_3D0.03_2D0.03_new.mat'...
    '124cams_3D0.03_2D0.03_new.mat', '134cams_3D0.03_2D0.03_new.mat'};
order_filename1 = [1234, 123, 124, 134];
load_filename2 = {'allcams_3D0.1_2D0.1_new.mat', '123cams_3D0.03_2D0.03_new.mat'...
    '124cams_3D0.03_2D0.03_new.mat', '234cams_3D0.03_2D0.03_new.mat'};
order_filename2 = [1234, 123, 124, 234];
load_filename3 = {'allcams_3D0.1_2D0.1_new.mat', '123cams_3D0.03_2D0.03_new.mat'...
    '134cams_3D0.03_2D0.03_new.mat', '234cams_3D0.03_2D0.03_new.mat'};
order_filename3 = [1234, 123, 134, 234];
load_filename4 = {'allcams_3D0.1_2D0.1_new.mat', '124cams_3D0.03_2D0.03_new.mat'...
    '134cams_3D0.03_2D0.03_new.mat', '234cams_3D0.03_2D0.03_new.mat'};
order_filename4 = [1234, 124, 134, 234];

%% combining the triangulation points from 2D tracks to get the best 3D track fit

tracks3D = cell(1,1);
good_trk = [6 8 10 14 19 25 28 34 35 37  44 48 50];
for trk = good_trk %1:20000
    
    track3D_isolated = zeros(1,8);
    cam = long_trackIDs(trk,3);
    for i = 1:4
        eval(['load(load_filename' num2str(cam) '{i});']);
        for frame = 5:196
            eval(['fr = frame' num2str(frame) ';']);
            % re-ordering the 2D pos to match the camera number
            if (eval(['order_filename' num2str(cam) '(i)']) == 123) 
            elseif (eval(['order_filename' num2str(cam) '(i)']) == 234) 
                fr(:,[5:7 4]) = fr(:,4:7); 
            elseif (eval(['order_filename' num2str(cam) '(i)']) == 134)
                fr(:,[6:7 5]) = fr(:,5:7); 
            elseif (eval(['order_filename' num2str(cam) '(i)']) == 124)
                fr(:,[7 6]) = fr(:,6:7);
            end         
            
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
    figure(4); hold off
%     subplot(1,2,2)
    tracks3D{trk,1} = robustSpline_3DTrackFit(track3D_isolated, tr_images, tr1, tr2, tr3, tr4,camParaCalib, 8, cam);
    M(trk) = getframe;
    
end
%%
figure;
hold on
for i = 1:size(track3D_isolated,1)
    b1 = track3D_isolated(i,5)/max(track3D_isolated(:,5));
    c = 0;%track3D_isolated(i,6)/max(track3D_isolated(:,6));
    a1 = 0;
    col = [a1 b1 c];
    plot3(track3D_isolated(i,1), track3D_isolated(i,2),track3D_isolated(i,3), 'Color', col, 'Marker', '.', 'LineStyle', 'none')
end