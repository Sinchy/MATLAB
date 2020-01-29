function img1 = Overlapandcheck(path,tracks, cam, beforeVSCpath, frame_range, afterVSCpath)
%path = '/home/tanshiyong/Documents/Data/Mass-Transfer/2018-11-06/ForVSC_100fps/cam1/';
c = double(imread([path 'cam' num2str(cam) '/cam' num2str(cam) 'frame' num2str(frame_range(1),'%06.0f') '.tif']));
[h, w] = size(c);
img1 = zeros(h, w);
for i = frame_range(1):frame_range(2)
    c = double(imread([path 'cam' num2str(cam) '/cam' num2str(cam) 'frame' num2str(i,'%06.0f') '.tif']));
    img1 = max(img1,c);
end
img1 =  uint8(img1);
% figure; 
imshow(uint8(img1));
load(beforeVSCpath);
addpath ~/Documents/Code/MATLAB/Post_analysis/
% trackspath = [path '/Tracks/ConvergedTracks/'];
% tracks = ReadAllTracks(trackspath);
tracks_interest = tracks( tracks(:, 4) >= frame_range(1) & tracks(:, 4) <= frame_range(2), :);
pos2d_old = calibProj_Tsai(camParaCalib(cam), tracks_interest(:,1:3));
hold on
plot(pos2d_old(:,1), pos2d_old(:,2), 'b.', 'MarkerSize',12);
% plot(pos2d_old(1,1), pos2d_old(1,2), 'y*');
if exist('afterVSCpath', 'var')
    load(afterVSCpath);
    pos2d_new = calibProj_Tsai(camParaCalib(cam), tracks_interest(:,1:3));
    plot(pos2d_new(:,1), pos2d_new(:,2), 'r.', 'MarkerSize',12);
end
hold off;
% fig = figure;
% PlotTracks(tracks, fig, 'r.');
end