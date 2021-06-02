function [ hnd_figure ] = compareTracksAndPos( settings, tracks, frameRange, posRange )
% This function plots the detected particle positions in desired frames
% together with the tracks that have been assigned in this frame range

%% preferences
if nargin<4
    posRange = [-inf inf ; -inf inf ; -inf inf];
end

%% filter tracks for desired range

% frameRange:
trajs = convertToTraj(tracks);
trajs = traj_cutFrames(trajs, frameRange);

% filter for positions:




%% plot
hnd_figure = figure;
hold on;
cMap = jet(frameRange(end)-frameRange(1)+1);
for k = frameRange(1):frameRange(end)
    data3d = dlmread(sprintf([settings.output3Dcoords '/clustered/coords3d_%05d.dat'],k));
    plot3(data3d(:,1),data3d(:,2),data3d(:,3),'.','Color',cMap(k,:));
end


cMap = parula(numel(trajs));
for k = 1:numel(trajs)
    plot3(trajs{k}(:,12),trajs{k}(:,13),trajs{k}(:,14),'Color',cMap(k,:),'LineWidth',5);
end


end

