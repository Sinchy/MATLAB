function tracks = AddMeanFlow(tracks, mean_velocity, frame_rate)
% adding mean velocity to the x direction
tracks = sortrows(tracks, 5);
tracks(:, 6:8) = tracks(:, 6:8); % / 10; % make the fluctuation smaller
tracks(:, 8) = tracks(:, 8) + mean_velocity;
track_ID = unique(tracks(:,5));
max_trID = max(track_ID);
for i = 1 : size(track_ID, 1)
    track_one = tracks(tracks(:, 5) == track_ID(i), :);
    for j = 2 : size(track_one, 1)
        track_one(j, 3) = track_one(j - 1, 3) + track_one(j - 1, 8) / frame_rate;
%         if track_one(j, 3) > 20
%             track_one(j, 3) = track_one(j, 3) - 20;
%             track_one(j:end, 5) = max_trID;
%             max_trID = max_trID + 1;
%         elseif track_one(j, 3) < -20
%             track_one(j, 3) = track_one(j, 3) + 20;
%             track_one(j:end, 5) = max_trID;
%             max_trID = max_trID + 1;            
%         end
    end
    tracks(tracks(:, 5) == track_ID(i), :) = track_one;
end
end

