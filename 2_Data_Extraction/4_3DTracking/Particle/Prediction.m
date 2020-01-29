function [est_point, error] = Prediction(active_long_tracks)
%     [track_num, frame_num, ~] = size(active_long_tracks);
    track_num = max(active_long_tracks(:, 5)) - min(active_long_tracks(:, 5)) + 1;
    track_no = unique(active_long_tracks(:, 5));
    frame_num = max(active_long_tracks(:, 4));
    est_point = zeros(track_num, 3);
    error = zeros(track_num, 1);
    for i = 1 : track_num
%         track = reshape(active_long_tracks(i, :, :), frame_num, 3);
        track = active_long_tracks(active_long_tracks(:, 5) == track_no(1), :);
%         while (track(1,1) == 0 && track(1,2) == 0 && track(1,3) ==0) 
%             track(1,:) = []; % delete the zero points
%         end
        [length, ~] = size(track);
        if length < 6
            order = length - 1;
        else
            order = 5;
        end
        error0 = zeros(1,3);
        for k = 1 : 3
            [est_point(i, k), error0(k)] = LMSWienerPredictor(track(:,k), order);
        end
        error(i) = norm(error0);
    end
end
