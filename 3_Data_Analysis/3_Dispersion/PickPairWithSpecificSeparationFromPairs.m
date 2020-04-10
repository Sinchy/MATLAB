function new_pair = PickPairWithSpecificSeparationFromPairs(pairs, tracks, separation)
num_pair = size(pairs, 1);
new_pair = zeros(num_pair, 4);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    disp = vecnorm(track1(1:len, 1:3) - track2(1:len, 1:3), 2, 2);
    frame_index = find(disp >= separation(1) & disp <= separation(2), 1, 'first');
    if ~isempty(frame_index)
        new_pair(i, :) = [track1(1,5), track2(1,5), track1(frame_index, 4), frame_index];
    end
end
new_pair(new_pair(:,1) == 0, :) = [];
end

