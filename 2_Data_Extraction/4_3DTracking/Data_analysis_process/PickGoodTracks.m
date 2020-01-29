function tracks = PickGoodTracks(tracks, view_size)
    num_tracks = max(tracks(:, 1));
    std_error = view_size / 1024;
    for i = 1 :  num_tracks
        track = tracks(tracks(:, 1) == i, 3 : 5);      
        if size(track, 1) < 20 
            tracks(tracks(:, 1) == i, :) = []; % delete short tracks
            continue; 
        end
        error0 = zeros(1, 3);
        num_fit = 10;
        for j = 1 : 3
            p = polyfit(1:num_fit, track(end - num_fit + 1:end, j)', 3);
            track_est = polyval(p, 1:num_fit);
            error0(j) = std(track_est - track(end - num_fit + 1:end, j)');
        end
        error = norm(error0);
        
        if error > std_error
            tracks(tracks(:, 1) == i, :) = []; % delete bad tracks
        end
            
        if ~(mod(i, 1000))
            i
        end
    end
end

