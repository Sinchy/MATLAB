function [R, pairs, disp_matrix] = PairDispersionCalculation(data_map, pairs, direction)
tic
min_pair_len = 100;

if direction == 0
    pairs = sortrows(pairs, 3);
else
    pairs = sortrows(pairs, 3, 'descend');
end
pairs = sortrows(pairs, 2);
pairs = sortrows(pairs, 1);
pairs_label = [pairs(:,1) + pairs(:,2), pairs(:,1) .* pairs(:,2)];
[~, pair_index, ~] = unique(pairs_label, 'rows');
pairs = pairs(pair_index, :);

pairs(pairs(:,1) == 0, :) = []; 

if direction == 0
    pairs(pairs(:, 4) < min_pair_len, :) = [];
    max_pair_len = max(pairs(:, 4));
else
    pairs(abs(pairs(:, 5)) < min_pair_len, :) = [];
    max_pair_len = max(abs(pairs(:,5)));
end

% pairs(num_stat + 1:end, :) = []; 
num_pair = size(pairs, 1);
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

disp_matrix = zeros(num_pair, max_pair_len);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    if direction == 0
        track1 = track1(track1(:,4) >= pairs(i, 3), :);
        track2 = track2(track2(:,4) >= pairs(i, 3), :);
    else
        track1 = track1(track1(:,4) <= pairs(i, 3), :);
        track2 = track2(track2(:,4) <= pairs(i, 3), :);
        track1 = flip(track1);
        track2 = flip(track2);
    end
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    disp_vec = track1(1 : len, 1:3) - track2(1 : len, 1:3);
%     vel_vec = track1(1 : len, 6:8) - track2(1 : len, 6:8);
    disp_sca = vecnorm(disp_vec, 2, 2) ;
    disp_matrix(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1)) .^2 ;
end

%remove repeated pair
[~,index,~] = unique(disp_matrix(:,1));
disp_matrix = disp_matrix(index, :);
pairs = pairs(index, :);

R = zeros(max_pair_len, 1);
for i = 1 : max_pair_len
    disp = nonzeros(disp_matrix(:, i));
    if ~isempty(disp)
        R(i) = mean(disp);
    end
end

R = nonzeros(R);
toc

