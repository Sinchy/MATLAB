function [R, pairs, disp_matrix] = PairDispersion(tracks, d_0, pairs)
% tracks need to be equal frame rate

if ~exist('pairs', 'var')
    num_stat = 3000;
    
    [C,~,~] = unique(tracks(:,5));
    num_tracks = size(C, 1);

    %find pairs at the beginning of each track (which can be extend to any
    %time) but this would generate a huge number of pairs
    sample_rate = 1;
    total_tracks = round(num_tracks/sample_rate);
    pairs = cell(total_tracks, 1);
    id = 1;
    total_pair = 0;
    f = waitbar(0,'Please wait...');
    for i = 1 : sample_rate : num_tracks
       track =  tracks(tracks(:, 5) == C(i), :);
    %    if track(1,4) ~= 1
    %        continue;
    %    end
       point0 = track(1, 1 : 3);
       points = tracks(tracks(:,4) == track(1, 4), :);
       pair_trkID = points(vecnorm(points(:, 1:3) - point0(1,1:3), 2, 2) > d_0(1) & vecnorm(points(:, 1:3) - point0(1,1:3), 2, 2) < d_0(2), 5);
       % distance in one direction, x
    %    pair_trkID = points(abs(points(:, 1) - point0(1,1)) > d_0(1) & abs(points(:, 1) - point0(1,1)) < d_0(2), 5);
       num_pair = length(pair_trkID);
       pairs{id} = [ones(num_pair, 1) * track(1, 5) pair_trkID ones(num_pair, 1) * track(1, 4)];
       id = id + 1;
       if num_pair > 0
           total_pair = total_pair + num_pair;
           waitbar(total_pair/num_stat, f, 'processing...');
           if total_pair > num_stat
               break;
           end
       end
    end
    pairs = cell2mat(pairs);
    % pairs = unique(pairs, 'rows'); % delete repeated pairs
    pairs_check = [pairs(:,1) + pairs(:,2), pairs(:,1) .* pairs(:,2), pairs(:,3)];
    [~, ia, ~] = unique(pairs_check, 'rows');
    pairs = pairs(ia, :); % delete repeated pairs
end
num_pair = size(pairs, 1);

len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
disp_matrix = zeros(num_pair, len);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    disp_vec = track1(1 : len, 1:3) - track2(1 : len, 1:3);
%     disp_sca = vecnorm(disp_vec, 2, 2);
%     disp_matrix(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1)) .^ 2;
    disp_vec = disp_vec - disp_vec(1, 1:3);
    disp_matrix(i, 1 : len - 1) = vecnorm(disp_vec(2:end, 1:3), 2, 2) .^ 2;
end
len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
R = zeros(len - 1, 1);
for i = 1 : len - 1
    disp = nonzeros(disp_matrix(:, i));
    if ~isempty(disp)
        R(i) = mean(disp);
    end
end
R = nonzeros(R);
end

