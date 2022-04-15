function img1 = Overlapandcheck(path,tracks, radius, cam, beforeVSCpath, frame_range, skip_frame, afterVSCpath)
%path = '/home/tanshiyong/Documents/Data/Mass-Transfer/2018-11-06/ForVSC_100fps/cam1/';
c = double(imread([path 'cam_' num2str(cam) '/cam' num2str(cam) 'frame' num2str(frame_range(1),'%06.0f') '.tif']));
[h, w] = size(c);
img1 = zeros(h, w);
if ~exist('skip_frame', 'var')
    skip_frame = 1;
end
for i = frame_range(1):skip_frame:frame_range(2)
    c = double(imread([path 'cam_' num2str(cam) '/cam' num2str(cam) 'frame' num2str(i,'%06.0f') '.tif']));
%     c = imcomplement(c);
    img1 = max(img1,c);
end
img1 =  uint8(img1);
%  figure; 
%  imshow(uint8(img1(494:567, 755:821)));
imshow(uint8(img1));
load([path beforeVSCpath]);
% addpath ~/Documents/Code/MATLAB/Post_analysis/
% trackspath = [path '/Tracks/ConvergedTracks/'];
% tracks = ReadAllTracks(trackspath);
% tracks_interest = tracks( tracks(:, 4) >= frame_range(1) & tracks(:, 4) <= frame_range(2), :);
% plot frame by frame
for i =  frame_range(1)  : frame_range(2)
    tracks_interest = tracks( tracks(:, 4) == i, :);
    pos2d_old = calibProj_Tsai(camParaCalib(cam), tracks_interest(:,1:3));
    hold on
    plot(pos2d_old(:,1), pos2d_old(:,2), 'g.', 'MarkerSize',10);
    r = radius(ismember(radius(:,1), tracks_interest(:, 5)), 2) ;
%     [~, ind] = ColorCollision(tracks_interest(:, 1:3), r);
%     plot(pos2d_old(ind,1), pos2d_old(ind,2), 'r.', 'MarkerSize',10, 'LineWidth', 2);
%     C = ColorCollision(tracks_interest(:, 1:3), r);
%     scatter(pos2d_old(:,1), pos2d_old(:,2), 4, C);
end
% plot(pos2d_old(:,1) - 755, pos2d_old(:,2) -494, 'b*', 'MarkerSize',12);
% plot(pos2d_old(1,1), pos2d_old(1,2), 'y*');
if exist('afterVSCpath', 'var')
    load(afterVSCpath);
    pos2d_new = calibProj_Tsai(camParaCalib(cam), tracks_interest(:,1:3));
    plot(pos2d_new(:,1), pos2d_new(:,2), 'r.', 'MarkerSize',12);
end
hold off;
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
% fig = figure;
% PlotTracks(tracks, fig, 'r.');
end

function [C, ind] = ColorCollision(data, r)
    n_p = size(data, 1);
    C = ones(n_p, 1) * [0 0 1];
    ind = zeros(n_p, 1);
    for i = 1 : n_p
        dist = vecnorm(data(i, :) - data(i + 1 : end, :), 2, 2);
        s_r = (r(i) + r( i + 1 : end));
        c = dist <= s_r + 0.2;
        if sum(c) > 0
            ind(i, 1) = 1;
            ind(i + 1 : end, 1) = ind(i + 1: end, 1) | c;
        end
    end
    ind = logical(ind);
    C(ind, :) = ones(sum(ind), 1) * [1 0 0];
    
end