function tracks = ReadTracks(filepath, totransform, num_frame)
fileID = fopen(filepath,'r');
formatspec = '%f,';
track_data = fscanf(fileID, formatspec);
total_len = length(track_data);
tracks = zeros(total_len / 5, 5);
for i = 1 :  total_len / 5
    tracks(i, :) = track_data((i - 1) * 5 + 1 : (i - 1) * 5 + 5);
end
if exist('totransform', 'var')
    tracks = TracksFormatTransform(tracks, num_frame);
end

fclose(fileID);
end

