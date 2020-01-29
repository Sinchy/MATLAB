function tracks_jumping = FindJumpingTracks(bubble_tracks)
trID = unique(bubble_tracks(:, 1));
thred = 0.2;
is_jump = zeros(size(trID, 1), 1);
for i = 1 : size(trID, 1)
    track = bubble_tracks(bubble_tracks(:, 1) == trID(i), [4 5 6 2 1]);
    if size(track,1) <= 4 
        continue;
    end
%     PlotTracks(track);
    err = LinearFitError(track);
    if sum(err > thred) 
        is_jump(i) = 1;
    end
%     is_jump(i)
%             pause(1)
end
tracks_jumping = bubble_tracks(ismember(bubble_tracks(:, 1), trID(is_jump == 1)), :);
end


function err =  LinearFitError(track)
% track_no = unique(data(:,5));
% num_track = size(track_no, 1);
% if num_track > 50000, num_track = 50000; end
% err_vec = [];
% for j = 1 : num_track
%     track = data(data(:,5) == track_no(j), :);
num_frame = size(track, 1);
for i = 4 : num_frame
   x = [1 1; 1 2; 1 3; 1 4];
   y = track(i - 3 : i, 1 : 3);
   b = x \ y;
   y_cal = x * b;
   err(i) = norm(y_cal(end, :) - y(end, :));
end
%     err_vec(j,1) = mean(nonzeros(err));
%     err_vec = [err_vec err];
% end
end
