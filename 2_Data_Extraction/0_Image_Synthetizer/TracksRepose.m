function tracks = TracksRepose(tracks_orig)
num_tracks = max(tracks_orig(:,5));
tracks = zeros(size(tracks_orig, 1), 5);
track_no = 1;
start = 1;
for  i = 1 : num_tracks
    track = tracks_orig(tracks_orig(:, 5) == i, :);
    [track, track_no] = bound(track, track_no);
    tracks(start : start + size(track, 1) - 1, :) = track;
    start = start + size(track, 1);
end
tracks(:, 1:3) = tracks(:, 1:3) * 50 / (2 * pi);
end

function [X, track_no] = bound(X, track_no) 
    inc = 1;
    X(:,5) = track_no;
    for i = 1 : 3
        if sum(X(:, i) > 2 * pi) > 0 
            X(X(:,i) > 2 * pi, 5) = X(X(:,i) > 2 * pi, 5) + inc;
            X(X(:,i) > 2 * pi, i) = X(X(:,i) > 2 * pi, i) - 2 * pi;
            inc = inc + 1;
        end
        if sum(X(:, i) < 0) > 0 
            X(X(:,i) < 0, 5) = X(X(:,i) < 0, 5) + inc;
            X(X(:,i) < 0, i) = X(X(:,i) < 0, i) + 2 * pi;
            inc = inc + 1;
        end
    end
    track_no = track_no + inc;
    
%     if (X > 2 * pi)
%         x = X - 2 * pi;
%     elseif (X < 0)
%         x = X + 2 * pi;
%     end
end