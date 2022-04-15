bb_small_id = radius(radius(:, 3) < 0.11, :);
bb_large_id = radius(radius(:, 3) > 0.2, :);
track_small = tracks(ismember(tracks(:,5), bb_small_id), :);
track_large = tracks(ismember(tracks(:,5), bb_large_id), :);

%%
tracks = track_large;
save('C:\Users\ShiyongTan\Documents\Data_processing\20220204\T3\results\filter_tracks.mat', 'tracks', '-v7.3');

%%
tracks = track_small;
save('C:\Users\ShiyongTan\Documents\Data_processing\20220204\T3\results\filter_tracks.mat', 'tracks', '-v7.3');