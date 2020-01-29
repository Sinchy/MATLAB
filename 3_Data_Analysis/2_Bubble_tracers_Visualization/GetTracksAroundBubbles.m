function tracks_around_bubble = GetTracksAroundBubbles(tracer_tracks_path, bubble_path, breakup_timerange, break_frame, search_radius, frames_ahead_after)
if ~exist('search_radius', 'var')
    search_radius = 15; % 
end
if ~exist('frames_ahead_after', 'var')
    frames_ahead_after = 20; % 
end
addpath 3-Bubble-breakup;
%get the bubble track
 bubble_tracks = Bubble_Data_2Find_Breakup_Main(bubble_path.calibpath, tracer_tracks_path, bubble_path.data_location_origin, bubble_path.data_location_reconstruct, breakup_timerange, break_frame);

% get the tracks
shift = 50;
track_frame_range = [breakup_timerange(1) - shift, breakup_timerange(2) + shift];
tracer_tracks = ashwanth_rni_vel_acc([tracer_tracks_path 'Tracks/ConvergedTracks/'], 3, 9, 4000, track_frame_range);
tracks_around_bubble = cell(1, breakup_timerange(2) - breakup_timerange(1) + 1);
for i = breakup_timerange(1) : breakup_timerange(2)
   center_path = bubble_tracks(bubble_tracks(:, 4) > i - frames_ahead_after & bubble_tracks(:, 4) < i + frames_ahead_after, :);
   if isempty(center_path)
       continue;
   end
   % get a rough volume
   max_x = max(center_path(:, 1)) + search_radius;
   max_y = max(center_path(:, 2)) + search_radius;
   max_z = max(center_path(:, 3)) + search_radius;
   min_x = min(center_path(:, 1)) - search_radius;
   min_y = min(center_path(:, 2)) - search_radius;
   min_z = min(center_path(:, 3)) - search_radius;
   
   tracer_specific_frame = tracer_tracks( tracer_tracks(:, 4) == i, :);
   
   tracer_specific_frame = tracer_specific_frame( tracer_specific_frame(:, 1) > min_x & tracer_specific_frame(:, 1) < max_x ...
       & tracer_specific_frame(:, 2) > min_y & tracer_specific_frame(:, 2) < max_y...
       & tracer_specific_frame(:, 3) > min_z & tracer_specific_frame(:, 3) < max_z, :);
   
   select_label = zeros(size(tracer_specific_frame, 1), 1);
   for j = 1 : size(center_path, 1)
       distance = vecnorm(tracer_specific_frame(:, 1 : 3) - center_path(j, 1 : 3), 2, 2);
       select_label = distance < search_radius | select_label;
   end
   tracks_around_bubble{1, i - breakup_timerange(1) + 1} = tracer_specific_frame(select_label, :);
end
tracks_around_bubble = cell2mat(tracks_around_bubble');
GetVTK(tracks_around_bubble, 1, tracer_tracks_path);
end

