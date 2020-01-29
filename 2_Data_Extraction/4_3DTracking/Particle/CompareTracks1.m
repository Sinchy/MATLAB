bound_low = 5; 
bound_up = 15;
frame_no = 10;

track_org = track_org_2;
ind1 = find(track_org(:,frame_no,1) < bound_up & track_org(:,frame_no,1) > bound_low & track_org(:,frame_no,2) < bound_up & track_org(:,frame_no,2) > bound_low ...
    & track_org(:,frame_no,3) < bound_up & track_org(:,frame_no,3) > bound_low);

track_compare = track_code;
ind2 = find(track_compare(:,frame_no,1) < bound_up & track_compare(:,frame_no,1) > bound_low & track_compare(:,frame_no,2) < bound_up & track_compare(:,frame_no,2) > bound_low ...
    & track_compare(:,frame_no,3) < bound_up & track_compare(:,frame_no,3) > bound_low);

% track_compare = track_LaV;
% ind3 = find(track_compare(:,frame_no,1) < bound_up & track_compare(:,frame_no,1) > bound_low & track_compare(:,frame_no,2) < bound_up & track_compare(:,frame_no,2) > bound_low ...
%     & track_compare(:,frame_no,3) < bound_up & track_compare(:,frame_no,3) > bound_low);
% 
% track_compare = inactive_long_tracks_50;
% ind4 = find(track_compare(:,frame_no,1) < bound_up & track_compare(:,frame_no,1) > bound_low & track_compare(:,frame_no,2) < bound_up & track_compare(:,frame_no,2) > bound_low ...
%     & track_compare(:,frame_no,3) < bound_up & track_compare(:,frame_no,3) > bound_low);
% ind2 = find(active_long_tracks(:,frame_no,1) < bound_up & active_long_tracks(:,frame_no,1) > bound_low & active_long_tracks(:,frame_no,2) < bound_up & active_long_tracks(:,frame_no,2) > bound_low ...
%     & active_long_tracks(:,frame_no,3) < bound_up & active_long_tracks(:,frame_no,3) > bound_low);

% ind3 = find(inactive_long_tracks(:,frame_no,1) < bound_up & inactive_long_tracks(:,frame_no,1) > bound_low & inactive_long_tracks(:,frame_no,2) < bound_up & inactive_long_tracks(:,frame_no,2) > bound_low ...
%     & inactive_long_tracks(:,frame_no,3) < bound_up & inactive_long_tracks(:,frame_no,3) > bound_low);
% 
% ind4 = find(exit_tracks(:,frame_no,1) < bound_up & exit_tracks(:,frame_no,1) > bound_low & exit_tracks(:,frame_no,2) < bound_up & exit_tracks(:,frame_no,2) > bound_low ...
%     & exit_tracks(:,frame_no,3) < bound_up & exit_tracks(:,frame_no,3) > bound_low);


track1 = track_org(ind1,1:50,:);
track2 = track_code(ind2,1:50,:);
% track3 = track_LaV(ind3,1:50,:);
% track4 = inactive_long_tracks_50(ind4,:,:);
% track2 = active_long_tracks(ind2,:,:);
% track3 = inactive_long_tracks(ind3,:,:);
% track4 = exit_tracks(ind4,:,:);

fig = figure;
PlotTracks(fig, track1, 'b-'); hold on
PlotTracks(fig, track2, 'r.-');
% PlotTracks(fig, track3, 'g.-');
% PlotTracks(fig, track4, 'b.-');
% PlotTracks(fig, track3, 'g.-');
% PlotTracks(fig, track4, 'm.-');
