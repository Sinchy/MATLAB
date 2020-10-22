function cor_velacc_matrix = CorrelationVelAcc(data_map, pairs, direction)
min_pair_len = 100;
% Get tracks
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);
% Get track info
[trackID, start_index, ic] = unique(tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, start_index, a_counts];

num_pair = size(pairs, 1);
if direction == 0
    pairs(pairs(:, 4) < min_pair_len, :) = [];
    max_pair_len = max(pairs(:, 4));
else
    pairs(abs(pairs(:, 5)) < min_pair_len, :) = [];
    max_pair_len = max(abs(pairs(:,5)));
end

cor_velacc_matrix = zeros(num_pair, max_pair_len);
for i = 1 : num_pair
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
    
    % Relative velocity
    veldiff_vec = (track1(1 : len, 6:8) - track2(1 : len, 6:8)) / 1e3;
    
    % Relative acceleration
   accdiff_vec = (track1(1 : len, 9:11) - track2(1 : len, 9:11)) / 1e3;
    
   cor_vel_acc = dot(veldiff_vec, accdiff_vec, 2);
   
   cor_velacc_matrix(i, 1:len) = cor_vel_acc;
end

end

