function [ACF, ACF_array] = AccelCF(data_map,pairs)
%Pair relative acceleration correlation function
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);
num_pair = size(pairs, 1);

% len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
[~, ~, ic] = unique(tracks(:, 5));
tk_len = accumarray(ic,1);
max_len = max(tk_len);
ACF_array = zeros(num_pair, max_len);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    if len < 20
        continue;
    end
    direction = track1(1 : len, 1:3) - track2(1 : len, 1:3);
    direction = direction ./ vecnorm(direction, 2, 2);
    acceldiff_vec = track1(1 : len, 9:11) - track2(1 : len, 9:11);
    acceldiff_lgtn = dot(acceldiff_vec, direction, 2);
    lags = length(acceldiff_lgtn) - 19;
    acf = autocorr(acceldiff_lgtn, 'NumLags',lags);
    ACF_array(i, 1 : size(acf, 1)) = acf;
end

ACF = zeros(max_len - 19, 1);
for i = 1 : max_len - 19
    ACF(i) = mean(nonzeros(ACF_array(:, i)));
end

end

