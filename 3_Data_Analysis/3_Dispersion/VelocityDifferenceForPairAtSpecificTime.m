function vel_diff_mag = VelocityDifferenceForPairAtSpecificTime(tracks, pairs, time)
num_pair = size(pairs, 1);
vel_diff = inf * ones(num_pair, 3);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    if len < time
        continue;
    end
    vel_diff(i, 1:3) = track1(time, 6 : 8) - track2(time, 6 : 8);
end
vel_diff(vel_diff(:, 1) == inf, :) = [];
vel_diff_mag = vecnorm(vel_diff, 2, 2);
end

