function [R, pairs, disp_matrix, IS, veldiff_matrix, veldiff_pl_matrix, sep_matrix] = PairDispersionCalculation(data_map, pairs, direction)
tic
min_pair_len = 100;

if direction == 0
    pairs = sortrows(pairs, 3);
else
%     pairs = sortrows(pairs, 3);
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

[trackID, start_index, ic] = unique(tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, start_index, a_counts];

disp_matrix = zeros(num_pair, max_pair_len);
veldiff_matrix = zeros(num_pair, max_pair_len);
veldiff_pl_matrix = zeros(num_pair, max_pair_len); % velocity difference along the separation direction
IS = zeros(num_pair, 1);
sep_matrix = zeros(num_pair, max_pair_len);
for i = 1 : num_pair
%     track1 = tracks(tracks(:,5) == pairs(i, 1), :);
%     track2 = tracks(tracks(:,5) == pairs(i, 2), :); % very slow 
    
    track1_info = tr_info(tr_info(:, 1) == pairs(i, 1), :);
    track1 = tracks(track1_info(2) : track1_info(2) + track1_info(3) - 1, :);
    track2_info = tr_info(tr_info(:, 1) == pairs(i, 2), :);
    track2 = tracks(track2_info(2) : track2_info(2) + track2_info(3) - 1, :);   
    
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
    
    veldiff_vec = (track1(1 : len, 6:8) - track2(1 : len, 6:8)) / 1e3;
    veldiff_sca = vecnorm(veldiff_vec, 2, 2).^2;
    veldiff_matrix(i, 1 : len ) = veldiff_sca;
    
    disp_dr = disp_vec ./ vecnorm(disp_vec, 2, 2);
    veldiff_lgtn = dot(veldiff_vec, disp_dr, 2);
    veldiff_pl_matrix(i, 1 : len) = veldiff_lgtn;
    
    disp_sca = vecnorm(disp_vec, 2, 2) ;
    IS(i) = disp_sca(1);
    sep_matrix(i, 1:len) = disp_sca;
    disp_matrix(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1)) .^2 ;
end

%remove repeated pair
[~,index,~] = unique(disp_matrix(:,1));
disp_matrix = disp_matrix(index, :);
pairs = pairs(index, :);
veldiff_matrix = veldiff_matrix(index, :);
veldiff_pl_matrix = veldiff_pl_matrix(index, :);
IS = IS(index);
sep_matrix = sep_matrix(index, :);

R = zeros(max_pair_len, 1);
for i = 1 : max_pair_len
    disp = nonzeros(disp_matrix(:, i));
    if ~isempty(disp)
        R(i) = mean(disp);
    end
end

R = nonzeros(R);
toc

