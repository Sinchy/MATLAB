tracks_o = [];
for i = 20 : 20 : 5000
    tracks_frame = tracks(tracks(:,4) == i, :);
    tracks_frame(:,4) = i / 20;
    tracks_o = [tracks_o; tracks_frame];
end
tracks_o = sortrows(tracks_o, 5);