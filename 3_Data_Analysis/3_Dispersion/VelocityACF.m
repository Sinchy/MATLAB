function [ACF, zero_point] = VelocityACF(tracks)
[C,~,ic] = unique(tracks(:,5));
% num_tracks = size(C, 1);
a_counts = accumarray(ic,1); % length of each track 
track_info = [C a_counts];
track_info = sortrows(track_info, 2); 
% get the most lengthest tracks
% max_track_num = 1000;
max_track_num = size(a_counts,1);
if size(a_counts,1) < max_track_num, max_track_num = size(a_counts,1); end
track_info = track_info(end - max_track_num + 1 : end, :);
max_len = max(track_info(:, 2));
ACF_array = zeros(max_len - 19, max_track_num);
zero_point = zeros(max_track_num, 1);
for i = 1 : max_track_num
    track = tracks(tracks(:, 5) == track_info(i, 1), :);
    lags = track_info(i, 2) - 19;
    acf = autocorr(track(:, 8), 'NumLags',lags);
    ACF_array(1 : size(acf, 1), i) = acf;
    [~,zero_point(i)] = min(abs(acf - .5)); % the time to decay to 0.5
    %if abs(zero_points) > 0.1, zero_point(i) = 0; end %if zero points is too large, it means there is no zeropoint.
end
ACF = zeros(max_len - 19, 1);
for i = 1 : max_len - 19
    ACF(i) = mean(nonzeros(ACF_array(i, :)));
end
end

 