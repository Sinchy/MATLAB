function tracks = PickGoodTracks(tracks, view_size)
    constant_tracks = parallel.pool.Constant(tracks);
    num_tracks = max(tracks(:, 5));
    num_particles = size(tracks, 1);
    std_error = view_size / 1024;
    delete_index = zeros(1, num_tracks + 1);
    
    fprintf('\t Completion: ');
    showTimeToCompletion; startTime=tic;
    percent = parfor_progress(num_tracks);
    
    parfor i = 0 :  num_tracks
        percent = parfor_progress;
        showTimeToCompletion( percent/100, [], [], startTime );
        
        % get the track data for the ith track
        for j = 1 : num_particles
            start = j;
            num_element = 0;
            while constant_tracks.Value(start + num_element, 5) == i
                num_element = num_element + 1;
            end
            if num_element > 0 
                track = constant_tracks.Value(start : start + num_element - 1, 1 : 3);
                break;
            end
        end
%         track = constant_tracks.Value(constant_tracks.Value(:,5) == i, 1 : 3);
        if size(track, 1) < 20 
%             tracks(tracks(:, 1) == i, :) = []; % delete short tracks
            delete_index(1, i + 1) = 1; % lable this track will be deleted
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
%             tracks(tracks(:, 1) == i, :) = []; % delete bad tracks
              delete_index(1, i + 1) = 1; % lable this track will be deleted
        end
            
%         if ~(mod(i, 1000))
%             i
%         end
        
    end
    for i = 0 :  num_tracks
        if delete_index(1, i + 1)
            tracks(tracks(:, 1) == i, :) = [];
        end
    end
end

