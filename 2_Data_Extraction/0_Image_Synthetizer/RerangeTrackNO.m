num_particle = size(tracks,1);
track_no = 1;
for i = 1 : num_particle - 1
    if tracks(i, 5) == tracks(i + 1, 5)
        tracks(i, 5) = track_no;
    else
        tracks(i, 5) = track_no;
        track_no = track_no + 1;
    end
end
tracks(end,5) = track_no;