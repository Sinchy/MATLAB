function [fit_percent, fit, correctness] = CompareTracks(track0_map, track1_map, show_image, save_path, range, load_result)
% track0: the original track
% track1: the track to be compared
% [num_track0, num_frame, ~] = size(track0);
num_track0 = max(track0_map.Data.tracks(:,5)); 
% num_frame = max(track0(:,4));
% [num_track1, ~, ~] = size(track1);
num_track1 = max(track1_map.Data.tracks(:,5)); 
% num_particle = size(track0_map.Data.tracks, 1);
tolerant = 5e-2;
if ~exist('load_result','var')
    fit = zeros(num_track0, 4); % the indicator for fitability for each track,
                                % the first value is the percentage of fitability, 
                                % the second value is the number of tracks to be fitted.
                                % Track length
                                % fit error
    correctness = zeros(1, num_track1); % the number of particles which are in the right track
    start_point = 1;
else
    load(load_result);
    for i = num_track0 : -1 : 1
        if (fit(i, 1) == 0) 
            continue;
        else
            start_point = i + 1;
            break;
        end
    end
end

if show_image fig = figure('Visible', 'on'); end
for i = range(1) : range(2)     % go over every track
    fit_number = 0;
    fit_track_number = 0;
    track_to_fit = track0_map.Data.tracks(track0_map.Data.tracks(:,5) == i, :);
    
    if show_image
%         PlotTracks(fig, track0(i, :, :), 'b.'); % plot the track 
        PlotTracks(track_to_fit, fig, 'b.');
        hold on
    end
    j = 1;
    num_frame = size(track_to_fit, 1);
    fit_error = 0;

    while (j <= num_frame)   % go over every frame

        point = track_to_fit(j, 1:3);
        particle_frame = track1_map.Data.tracks(track1_map.Data.tracks(:,4) == track_to_fit(j,4), :);

        candidate = particle_frame(particle_frame(:, 1) > point(1) - tolerant & particle_frame(:, 1) < point(1) + tolerant & ...
            particle_frame(:, 2) > point(2) - tolerant & particle_frame(:, 2) < point(2) + tolerant & ...
            particle_frame(:, 3) > point(3) - tolerant & particle_frame(:, 3) < point(3) + tolerant, :);

        if isempty(candidate)
            j = j + 1;
            continue;
        end
        dist = norm(candidate(:, 1:3) - point);

        [min_dist, index_i] = min(dist);
        l = j;
        index = candidate(index_i, 5); % track no.
        track_match = track1_map.Data.tracks(track1_map.Data.tracks(:,5) == index, :);
        match_index = find(track_match(:,4) == candidate(index_i, 4));
        fit_error =  fit_error + min_dist;
        while (min_dist < tolerant) % find a fitted particle
            % try to evaluate the following particles
            if l == j
                fit_track_number = fit_track_number + 1;
                if show_image PlotTracks(track_match, fig, 'r.'); end
            else
                if show_image PlotTracks(track_match(match_index, :), fig, 'g*'); end
                pause(.01);
            end
           fit_number = fit_number + 1;
           correctness(index) = correctness(index) + 1; % increase the number of correct particle in the track
           l = l + 1;
           match_index = match_index + 1;
           if l > num_frame || match_index > size(track_match, 1)
               break; 
           end
           min_dist = norm(track_to_fit(l, 1:3) - track_match(match_index, 1:3));
           fit_error = fit_error + min_dist;
        end
        if j ~= l && j ~= num_frame 
            j = l - 1;
        end
        j = j + 1;
    end
    fit(i, 3) = num_frame;
    fit(i, 1) = fit_number;
    fit(i, 2) = fit_track_number;
    fit(i, 4) = fit_error / fit_number;
    if show_image hold off; end
    if ~(mod(i, 100)) 
        i
         save(save_path, 'fit', 'correctness');
    end
end
    fit_percent = sum(fit(:, 1)) / sum(fit(:, 3));
end

