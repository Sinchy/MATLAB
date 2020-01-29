function tracks = ReshapeTracks(data)
[~, num_track, num_frame] = size(data);
tracks = zeros(num_track * num_frame,5);
for i = 1 : num_track
   track = reshape(data(:, i, :), [3 num_frame])';
   tracks((i - 1) * num_frame + 1: i * num_frame, :) = [track (1 : num_frame)' ones(num_frame, 1) * i];
end

end

