function tracks = PickGoodTracks(tracks, view_size)
    num_tracks = max(tracks(:, 5));
    std_error = view_size / 1000;
    num_good = ceil(num_tracks * .1);
    if num_tracks * .1 > 1000,  nun_good = 1000; end
    error_pool = zeros(1, num_good);
    no_good = 1;
    for i = 1 :  num_tracks
        track = tracks(tracks(:, 5) == i, 1 : 3);      
        if size(track, 1) < 20 
            tracks(tracks(:, 1) == i, :) = []; % delete short tracks
            continue; 
        end
        error0 = zeros(1, 3);
        num_fit = 10;
        for j = 1 : 3
            p = polyfit(1:num_fit, track(end - num_fit + 1:end, j)', 3);
            track_est = polyval(p, 1:num_fit);
            error0(j) = mean(abs(track_est - track(end - num_fit + 1:end, j)'));
        end
        error = norm(error0);
        
        if error > std_error
            tracks(tracks(:, 5) == i, :) = []; % delete bad tracks
        end
        
        if no_good <= num_good
            error_pool(1, no_good) = error;
            no_good = no_good + 1;
        elseif no_good == num_good + 1
            std_error = mean(error_pool) + 3 *  std(error_pool);
            no_good = num_good + 1;
        end
            
        if ~(mod(i, 1000))
            i
        end
    end
end

