function [disp, MSD] = PointDispersion(tracks)
[trID, ~, ic] = unique(tracks(:, 5));
tr_length = accumarray(ic, 1);
num_track = length(trID);
if num_track > 10000
    ind = randperm(num_track, 10000);
    trID = trID(ind);
    tr_length = tr_length(ind);
    num_track = 10000;
end
tr_length_max = max(tr_length);
disp = zeros(num_track, tr_length_max, 3);
for i = 1 : num_track
    track = tracks(tracks(:, 5) == trID(i), :);
    disp_r = track(:, 1:3) - track(1, 1:3);
    disp(i, 1:tr_length(i), :) = disp_r;
end
MSD = zeros(tr_length_max - 1, 6); % 1~3 for x y z, 4~6 for the 95% CI
for i = 2 : tr_length_max
    for j = 1 : 3
        dp = nonzeros(disp(:, i, j));
        SD = (dp - mean(dp)).^2;
        MSD(i-1, j) = mean(SD);
        MSD(i-1, j + 3) = 1.96 *  std(SD) / (size(SD, 1))^.5; % 95% CI
    end
end
end

