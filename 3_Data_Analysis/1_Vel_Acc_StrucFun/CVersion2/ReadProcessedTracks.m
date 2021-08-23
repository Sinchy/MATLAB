function tracks = ReadProcessedTracks(filepath)
fileID = fopen(filepath,'r');
formatspec = '%f,';
track_data = fscanf(fileID, formatspec);
total_len = length(track_data);
num_comp = 11;
tracks = zeros(total_len / num_comp, num_comp);
for i = 1 :  total_len / num_comp
    tracks(i, :) = track_data((i - 1) * num_comp + 1 : (i - 1) * num_comp + num_comp);
end
% tracks = reshape(track_data, [total_len / num_comp, num_comp]);
% if exist('totransform', 'var')
%     tracks = TracksFormatTransform(tracks, num_frame);
% end

fclose(fileID);
end

