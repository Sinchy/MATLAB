function [fit_percent, fit, correctness] = CompareTracks(track0, track1, show_image, save_path, load_result)
% track0: the original track
% track1: the track to be compared
[num_track0, num_frame, ~] = size(track0);
% num_track0 = max(track0(:,5)); 
% num_frame = max(track0(:,4));
[num_track1, ~, ~] = size(track1);
% num_track1 = max(track1(:,5)); 
tolerant = 3e-1;
if ~exist('load_result','var')
    fit = zeros(num_track0, 3); % the indicator for fitability for each track,
                                % the first value is the percentage of fitability, 
                                % the second value is the number of tracks to be fitted.
                                % Track length
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
for i = start_point : num_track0      % go over every track
    fit_number = 0;
    fit_track_number = 0;
    if show_image
        PlotTracks(fig, track0(i, :, :), 'b.'); % plot the track 
        hold on
    end
    j = 1;
    zero_frame_number = 0;
    while (j <= num_frame)   % go over every frame
        if track0(i, j, 1) == 0 && track0(i, j, 2) == 0 && track0(i, j, 3) == 0 % skip zero frame
            zero_frame_number = zero_frame_number + 1;
            j = j + 1;
            continue;
        end
        point = reshape(track0(i, j, :), 1, 3);
        index_candidate =  find(track1(:, j, 1) > point(1) - tolerant & track1(:, j, 1) < point(1) + tolerant & ...
            track1(:, j, 2) > point(2) - tolerant & track1(:, j, 2) < point(2) + tolerant & ...
            track1(:, j, 3) > point(3) - tolerant & track1(:, j, 3) < point(3) + tolerant );
        len = length(index_candidate);
        dist = ones(1, len);
        for k = 1 :  len
            dist(k) = norm(reshape(track0(i, j, :) - track1(index_candidate(k), j, :), 1, 3));
        end
        [min_dist, index_i] = min(dist);
        l = j;
        index = index_candidate(index_i);
        while (min_dist < tolerant) % find a fitted particle
            % try to evaluate the following particles
            if l == j
                fit_track_number = fit_track_number + 1;
                if show_image PlotTracks(fig, track1(index, :, :), 'r.'); end
            else
                if show_image PlotTracks(fig, track1(index, l, :), 'g*'); end
                pause(.01);
            end
           fit_number = fit_number + 1;
           correctness(index) = correctness(index) + 1; % increase the number of correct particle in the track
           l = l + 1;
           if l > num_frame 
               break; 
           end
           min_dist = norm(reshape(track0(i, l, :) - track1(index, l, :), 1, 3));
        end
        if j ~= l && j ~= num_frame 
            j = l - 1;
        end
        j = j + 1;
    end
    fit(i, 3) = num_frame - zero_frame_number;
    fit(i, 1) = fit_number;
    fit(i, 2) = fit_track_number;
    if show_image hold off; end
    if ~(mod(i, 100)) 
        i
        save(save_path, 'fit', 'correctness');
    end
end
    fit_percent = sum(fit(:, 1)) / sum(fit(:, 3));
end

