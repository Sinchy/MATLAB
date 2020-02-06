function [R, disp_matrix]  = TracerPairDispersionAroundBubble(tracer_pair, tracer_tracks)
tracer_pair = cell2mat(tracer_pair);
[~, ia, ~] = unique(tracer_pair, 'rows');
tracer_pair = tracer_pair(ia, :); % delete repeated pairs
num_pair = size(tracer_pair, 1);

tracer_tracks = cell2mat(tracer_tracks);
[~, ia, ~] = unique(tracer_tracks(:, [4 5 15]), 'rows');
tracer_tracks = tracer_tracks(ia, :); % delete repeated tracks
tracer_tracks = sortrows(tracer_tracks, 5);
[~, ~, ic] = unique(tracer_tracks(:, 5));
a_counts = accumarray(ic,1);
len_max = max(a_counts);
f = waitbar(0,'Please wait...');
sample_rate = 100;
disp_matrix = zeros(round(num_pair / sample_rate), len_max);
 
for i = sample_rate : sample_rate : num_pair
    waitbar(i/num_pair, f, 'processing...');
    pair = tracer_pair(i, :);
    track1_id = pair(2);
    track2_id = pair(3);
    data_id = pair(1);
    track1 = tracer_tracks(tracer_tracks(:, 15) == data_id & ...
        tracer_tracks(:, 5) == track1_id, :);
    track2 = tracer_tracks(tracer_tracks(:, 15) == data_id & ...
        tracer_tracks(:, 5) == track2_id, :);
    start_frame = pair(4);
    end_frame = min(track1(end, 4), track2(end, 4));
    track1(track1(:,4) < start_frame | track1(:,4) > end_frame, :) = [];
    track2(track2(:,4) < start_frame | track2(:,4) > end_frame, :) = [];
    disp_vec = track1(:, 1:3) - track2(:, 1:3);
    disp_vec = disp_vec - disp_vec(1, 1:3);
    len = size(disp_vec, 1);
    disp_matrix(round(i/sample_rate), 1 : len) = vecnorm(disp_vec, 2, 2) .^ 2;
end

R = zeros(len_max - 1, 1);
for i = 1 : len_max - 1
    disp = nonzeros(disp_matrix(:, i + 1));
    if ~isempty(disp)
        R(i) = mean(disp);
    end
end
R = nonzeros(R);
end

