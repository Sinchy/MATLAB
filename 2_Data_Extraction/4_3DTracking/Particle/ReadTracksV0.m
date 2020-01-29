function tracks = ReadTracksV0(filepath)
fileID = fopen(filepath,'r');
formatspec = '%f,';
track_data = fscanf(fileID, formatspec);
num_tracks = track_data(1);
num_frames = track_data(2);
for i = 1 : num_tracks
    for j = 1 : num_frames
        tracks(i, j, :) = track_data(((i - 1) * num_frames * 3 + (j - 1) * 3 + 4): ...
                                             ((i - 1) * num_frames * 3 + (j - 1) * 3 + 6));
    end
end