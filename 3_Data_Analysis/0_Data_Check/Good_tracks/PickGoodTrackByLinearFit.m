function good_tracks = PickGoodTrackByLinearFit(tracks)
track_no = unique(tracks(:,5));
num_track = size(track_no, 1);
good_tracks = [];
h = waitbar(0,'Please wait...');
for j = 1 : num_track
    track = tracks(tracks(:,5) == track_no(j), :);
    num_frame = size(track, 1);
%     start_frame = min(track(:, 4));
%     end_frame = start_frame + 3;
%     if num_frame <= 10 
%         continue; 
%     end
    err = zeros(num_frame, 1);
    for i = 4 : num_frame
        x = [1 1; 1 2; 1 3; 1 4];
        y = track(i - 3 : i, 1 : 3);
        b = x \ y;
        y_cal = x * b;
        err(i) = norm(y_cal(end, :) - y(end, :));
%         if err < 0.05 
% %             end_frame = end_frame + 1;
%             continue;
%         else
%             if i < 10
%                 track = [];
%             else
%                 track(i : end, :) = [];
%             end
%             break;
%         end
    end
    
    delete = zeros(num_frame, 1);
    if num_frame < 20
        delete(:) = 1;
    end
    idx = find(err > .05);
    if ~isempty(idx)
        if idx < 20
            delete(1 : idx, :) = 1;
        end
        num_outlier = length(idx);
        for i = 2 : num_outlier
            if idx(i) - idx(i - 1) < 20
                delete(idx(i - 1) : idx(i), :) = 1;
            else
                delete(idx(i) - 20 : idx(i), :) = 1;
            end
        end
        if num_frame - idx(end) < 20
            delete(idx(end) : num_frame, :) = 1;
        else
            delete(idx(end) : idx + 20, :) = 1;
        end
    end
    track(delete == 1, :) = [];
    if ~isempty(track) && size(track, 1) < 20
        track = [];
    end
    good_tracks = [good_tracks; track];
    waitbar(j/num_track, h)
end
end

