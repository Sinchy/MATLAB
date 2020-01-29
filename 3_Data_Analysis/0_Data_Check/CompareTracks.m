function [fit_percent, fit, correctness] = CompareTracks(track0, track1, show_image, save_path, calib_path, load_result)
% track0: the original track
% track1: the track to be compared
% [num_track0, num_frame, ~] = size(track0);
load(calib_path);
% num_track0 = max(track0(:,5)); 
track_no = unique(track0(:,5));
num_track0 = size(track_no, 1);
% num_frame = max(track0(:,4));
% [num_track1, ~, ~] = size(track1);
% num_track1 = max(track1(:,5)); 
track_no1 = unique(track1(:,5));
num_track1 = size(track_no1, 1);
% num_particle = size(track0, 1);
tolerant = 5e-2;
if ~exist('load_result','var')
    fit = zeros(num_track0, 5); % the indicator for fitability for each track,
                                % the first value is the percentage of fitability, 
                                % the second value is the number of tracks to be fitted.
                                % Track length
                                % fit error
                                % fit error for smooth track
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
h = waitbar(0, 'Please wait...');
if show_image fig = figure('Visible', 'on'); end
for i = start_point : num_track0      % go over every track
    fit_number = 0;
    fit_track_number = 0;
    track_to_fit = track0(track0(:,5) == track_no(i), :);
    
    if show_image
%         PlotTracks(fig, track0(i, :, :), 'b.'); % plot the track 
        PlotTracks(track_to_fit, fig, 'b.');
        hold on
    end
    j = 1;
    num_frame = size(track_to_fit, 1);
    fit_error = 0;
    fit_smooth_error = [];

    while (j <= num_frame)   % go over every frame

        point = track_to_fit(j, 1:3);
        particle_frame = track1(track1(:,4) == track_to_fit(j,4), :);

        candidate = particle_frame(particle_frame(:, 1) > point(1) - tolerant & particle_frame(:, 1) < point(1) + tolerant & ...
            particle_frame(:, 2) > point(2) - tolerant & particle_frame(:, 2) < point(2) + tolerant & ...
            particle_frame(:, 3) > point(3) - tolerant & particle_frame(:, 3) < point(3) + tolerant, :);

        if isempty(candidate)
            j = j + 1;
            continue;
        end
        dist = norm(candidate(:, 1:3) - point);

        [min_dist, index_i] = min(dist);
	index_i = index_i(1); % make it as a scalar
        min_dist = min_dist(1);
	l = j;
        index = candidate(index_i, 5); % track no.
        track_match = track1(track1(:,5) == index, :);
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
           index_no = find(track_no1 == index);
           correctness(index_no) = correctness(index_no) + 1; % increase the number of correct particle in the track
           l = l + 1;
           match_index = match_index + 1;
           if l > num_frame || match_index > size(track_match, 1)
               break; 
           end
           min_dist = norm(track_to_fit(l, 1:3) - track_match(match_index, 1:3));
           fit_error = fit_error + min_dist;
        end
        
        if j ~= l && j ~= num_frame 
            % calculate the error after smoothing the track
            track_to_smooth = track_match( match_index - (l - j): match_index - 1, 1:3);
            len = size(track_to_smooth, 1);
            fitwidth = 14;
            filterwidth = 6;
            if len > 2 * fitwidth + 1
                fitl = 1:fitwidth;
                Av = 1./(2.*sum(exp(-(fitl.*fitl)./filterwidth^2))+1);
                rkernel = -fitwidth:fitwidth;
                rkernel = Av.*exp(-rkernel.^2./filterwidth^2);
                x1 = conv(track_to_smooth(:,1),rkernel,'valid');
                y1 = conv(track_to_smooth(:,2),rkernel,'valid');
                z1 = conv(track_to_smooth(:,3),rkernel,'valid');
                xtmp = [x1,y1,z1];
                dist = vecnorm(track_to_fit(j + fitwidth : l - fitwidth - 1, 1 : 3) - xtmp, 2, 2);
                fit_smooth_error = [fit_smooth_error; dist];
%                 if fit(i, 5) == 0
%                     fit(i, 5) = fit_smooth_error;
%                 else
%                     fit(i, 5) = mean([fit(i,5) fit_smooth_error]);
%                 end
            end
            j = l - 1;
            
        end
        j = j + 1;
    end
    num_untrackable = UntrackableNum(track_to_fit, camParaCalib);
    fit(i, 3) = num_frame - num_untrackable; % remove particles that can't be tracked
    fit(i, 1) = fit_number;
    fit(i, 2) = fit_track_number;
    fit(i, 4) = fit_error / fit_number;
    if ~isempty(fit_smooth_error) 
        fit(i, 5) = sum(fit_smooth_error) / size(fit_smooth_error, 1);
    end
    if show_image hold off; end
    if ~(mod(i, 100)) 
        i
        save(save_path, 'fit', 'correctness');
    end
    waitbar(i / num_track0, h, ['Processing your data: ' num2str(i/num_track0 * 100) '%']);
end
    fit_percent = sum(fit(:, 1)) / sum(fit(:, 3));
    save(save_path, 'fit', 'correctness', 'fit_percent');
end

function num_untrackable = UntrackableNum(track, camParaCalib)
num_untrackable = 0;
for i = 1 : size(track, 1)
    untrackable_num = 0;
    for j = 1 : 4
        X2D = calibProj_Tsai(camParaCalib(j),track(i, 1:3));
        xc = X2D(1); yc = X2D(2);
        if (xc < 2 || xc > 1022 || yc < 2 || yc > 1022) 
            untrackable_num = untrackable_num + 1;
        end
    end
    if untrackable_num > 1 
        num_untrackable = num_untrackable + 1;
    end
end
end
