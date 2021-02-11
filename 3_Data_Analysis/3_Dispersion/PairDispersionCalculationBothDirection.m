function [forward, backward, pairs] = PairDispersionCalculationBothDirection(data_map, pairs)
tic
min_pair_len = 10;

pairs = sortrows(pairs, 3);
pairs = sortrows(pairs, 2);
pairs = sortrows(pairs, 1);
pairs_label = [pairs(:,1) + pairs(:,2), pairs(:,1) .* pairs(:,2)];
[~, pair_index, label] = unique(pairs_label, 'rows');
% get the middle index
for i = 1 : length(pair_index)
    index_label = find(label == i);
    pair_index(i) = index_label(ceil(end/2), :); % get the middle occurence of the pair
end
pairs = pairs(pair_index, :);

pairs(pairs(:,1) == 0, :) = []; 

pairs(pairs(:, 4) < min_pair_len, :) = [];
pairs(abs(pairs(:, 5)) < min_pair_len, :) = [];
max_pair_len_f = max(pairs(:, 4));
max_pair_len_b = max(abs(pairs(:,5)));

% pairs(num_stat + 1:end, :) = []; 
num_pair = size(pairs, 1);
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

[trackID, start_index, ic] = unique(tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, start_index, a_counts];

disp_matrix_f = zeros(num_pair, max_pair_len_f);
veldiff_matrix_f = zeros(num_pair, max_pair_len_f);
veldiff_pl_matrix_f = zeros(num_pair, max_pair_len_f); % velocity difference along the separation direction
IS_f = zeros(num_pair, 1);
sep_matrix_f = zeros(num_pair, max_pair_len_f);
% cor_velacc_matrix_f = zeros(num_pair, max_pair_len_f);

disp_matrix_b= zeros(num_pair, max_pair_len_b);
veldiff_matrix_b = zeros(num_pair, max_pair_len_b);
veldiff_pl_matrix_b = zeros(num_pair, max_pair_len_b); % velocity difference along the separation direction
IS_b = zeros(num_pair, 1);
sep_matrix_b = zeros(num_pair, max_pair_len_b);
% cor_velacc_matrix_b = zeros(num_pair, max_pair_len_b);
for i = 1 : num_pair
%     track1 = tracks(tracks(:,5) == pairs(i, 1), :);
%     track2 = tracks(tracks(:,5) == pairs(i, 2), :); % very slow 
    
    track1_info = tr_info(tr_info(:, 1) == pairs(i, 1), :);
    track1 = tracks(track1_info(2) : track1_info(2) + track1_info(3) - 1, :);
    track2_info = tr_info(tr_info(:, 1) == pairs(i, 2), :);
    track2 = tracks(track2_info(2) : track2_info(2) + track2_info(3) - 1, :);   
    
    % forward 

    track1_f = track1(track1(:,4) >= pairs(i, 3), :);
    track2_f = track2(track2(:,4) >= pairs(i, 3), :);

    len1 = size(track1_f, 1);
    len2 = size(track2_f, 1);
    len = min(len1, len2);
    disp_vec = track1_f(1 : len, 1:3) - track2_f(1 : len, 1:3);
    
    veldiff_vec = (track1_f(1 : len, 6:8) - track2_f(1 : len, 6:8)) / 1e3;
    veldiff_sca = vecnorm(veldiff_vec, 2, 2).^2;
    veldiff_matrix_f(i, 1 : len ) = veldiff_sca;
    
    disp_dr = disp_vec ./ vecnorm(disp_vec, 2, 2);
    veldiff_lgtn = dot(veldiff_vec, disp_dr, 2);
    veldiff_pl_matrix_f(i, 1 : len) = veldiff_lgtn;
    
    disp_sca = vecnorm(disp_vec, 2, 2) ;
    IS_f(i) = disp_sca(1);
    sep_matrix_f(i, 1:len) = disp_sca;
    disp_matrix_f(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1)) .^2 ;
    
%     accdiff_vec = (track1_f(1 : len, 9:11) - track2_f(1 : len, 9:11)) / 1e3;
%     cor_vel_acc = dot(veldiff_vec, accdiff_vec, 2);
%     cor_velacc_matrix_f(i, 1:len) = cor_vel_acc;
    
    % backward
    track1_b = track1(track1(:,4) <= pairs(i, 3), :);
    track2_b = track2(track2(:,4) <= pairs(i, 3), :);
    track1_b = flip(track1_b);
    track2_b = flip(track2_b);
    
    len1 = size(track1_b, 1);
    len2 = size(track2_b, 1);
    len = min(len1, len2);
    disp_vec = track1_b(1 : len, 1:3) - track2_b(1 : len, 1:3);
    
    veldiff_vec = (track1_b(1 : len, 6:8) - track2_b(1 : len, 6:8)) / 1e3;
    veldiff_sca = vecnorm(veldiff_vec, 2, 2).^2;
    veldiff_matrix_b(i, 1 : len ) = veldiff_sca;
    
    disp_dr = disp_vec ./ vecnorm(disp_vec, 2, 2);
    veldiff_lgtn = dot(veldiff_vec, disp_dr, 2);
    veldiff_pl_matrix_b(i, 1 : len) = veldiff_lgtn;
    
    disp_sca = vecnorm(disp_vec, 2, 2) ;
    IS_b(i) = disp_sca(1);
    sep_matrix_b(i, 1:len) = disp_sca;
    disp_matrix_b(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1)) .^2 ;
    
%     accdiff_vec = (track1_b(1 : len, 9:11) - track2_b(1 : len, 9:11)) / 1e3;
%     cor_vel_acc = dot(veldiff_vec, accdiff_vec, 2);
%     cor_velacc_matrix_b(i, 1:len) = cor_vel_acc;
end

% disp_matrix_b = fliplr(disp_matrix_b);
% veldiff_matrix_b = fliplr(veldiff_matrix_b);
% veldiff_pl_matrix_b = fliplr(veldiff_pl_matrix_b);
% sep_matrix_b = fliplr(sep_matrix_b);

% disp_matrix = [disp_matrix_b, disp_matrix_f];
% [~,index,~] = unique(disp_matrix_f(:,1));%remove repeated pair
% clear disp_matrix_b disp_matrix_f;
% veldiff_matrix = [veldiff_matrix_b, veldiff_matrix_f];
% clear veldiff_matrix_b veldiff_matrix_f;
% veldiff_pl_matrix = [veldiff_pl_matrix_b, veldiff_pl_matrix_f];
% clear veldiff_pl_matrix_b veldiff_pl_matrix_f;
% sep_matrix = [sep_matrix_b, sep_matrix_f];
% clear sep_matrix_b sep_matrix_f;
% IS = [IS_b, IS_f];
% clear IS_b IS_f;
% 
% disp_matrix = disp_matrix(index, :);
% pairs = pairs(index, :);
% veldiff_matrix = veldiff_matrix(index, :);
% veldiff_pl_matrix = veldiff_pl_matrix(index, :);
% IS = IS(index,:);
% sep_matrix = sep_matrix(index, :);
% 
% max_pair_len = max_pair_len_f + max_pair_len_b;
% R = zeros(max_pair_len, 1);
% for i = 1 : max_pair_len
%     disp = nonzeros(disp_matrix(:, i));
%     if ~isempty(disp)
%         R(i) = mean(disp);
%     end
% end
% 
% R = nonzeros(R);

[~,index,~] = unique(disp_matrix_f(:,1));%remove repeated pair
%forward package
forward.disp_matrix_f = disp_matrix_f(index, :);
pairs = pairs(index, :);
forward.veldiff_matrix_f = veldiff_matrix_f(index, :);
forward.veldiff_pl_matrix_f = veldiff_pl_matrix_f(index, :);
forward.IS_f = IS_f(index,:);
forward.sep_matrix_f = sep_matrix_f(index, :);
% forward.cor_velacc_matrix = cor_velacc_matrix_f(index, :);

R_f = zeros(max_pair_len_f, 1);
for i = 1 : max_pair_len_f
    disp = nonzeros(disp_matrix_f(:, i));
    if ~isempty(disp)
        R_f(i) = mean(disp);
    end
end

R_f = nonzeros(R_f);
forward.R_f = R_f;

%Backward package
backward.disp_matrix_b = disp_matrix_b(index, :);
% pairs = pairs(index, :);
backward.veldiff_matrix_b = veldiff_matrix_b(index, :);
backward.veldiff_pl_matrix_b = veldiff_pl_matrix_b(index, :);
backward.IS_b = IS_b(index,:);
backward.sep_matrix_b = sep_matrix_b(index, :);
% backward.cor_velacc_matrix = cor_velacc_matrix_b(index, :);

R_b = zeros(max_pair_len_b, 1);
for i = 1 : max_pair_len_b
    disp = nonzeros(disp_matrix_b(:, i));
    if ~isempty(disp)
        R_b(i) = mean(disp);
    end
end

R_b = nonzeros(R_b);
backward.R_b = R_b;

toc
end

