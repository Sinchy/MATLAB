function tracks = ReadLaVisionData(track_data)
%track_data = LaVision_tracks;
num_tracks = max(track_data(:,10)); 
num_frames = max(track_data(:,9));
% Initialize tracks:
% for i = 1 : num_tracks
%     for j = 1 : num_frames
%         tracks(i, j , :) = [0, 0, 0];
%     end
% end
tracks = zeros(num_tracks, num_frames,3);

track_data = sortrows(track_data, 10); % range track_data according to track ID
[len, ~] = size(track_data); 
j = 1;
for i = 1 : num_tracks
    while (j <= len && track_data(j, 10) == i) 
        tracks(i, track_data(j, 9), :) = [track_data(j, 3), -track_data(j, 1), track_data(j,2)];
        j = j + 1;
    end
end