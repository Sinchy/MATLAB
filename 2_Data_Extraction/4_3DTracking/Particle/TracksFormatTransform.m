function old_tracks = TracksFormatTransform(new_tracks, frame_number)
num_track = max(new_tracks(:, 1));
if (exist('frame_number', 'var')) 
    num_frame = frame_number;
else
    num_frame = max(new_tracks(:, 2));  
end
old_tracks = zeros(num_track, num_frame, 3);
for i = 0 : num_track
    track = new_tracks(find(new_tracks(:, 1) == i), :);
    start_frame = track(1, 2);
    end_frame = track(end, 2);
    old_tracks(i + 1, start_frame :  end_frame, :) = track(:, 3 : 5);
    if ~mod(i, 100)
       [num2str(i), '/' num2str(num_track)] 
    end
end
end

