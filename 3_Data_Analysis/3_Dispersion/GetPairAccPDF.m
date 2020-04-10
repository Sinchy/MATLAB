function [PDF, acc_sca, acc_matrix] = GetPairAccPDF(tracks, pairs, time)
num_pair = size(pairs, 1);

acc_matrix = zeros(num_pair, 6);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    if len > time
        acc_matrix(i, :) = [track1(time, 9:11) track2(time, 9:11)];
    end
end

% get PDF for acc diff
acc_sca = vecnorm(acc_matrix(:, 1:3) - acc_matrix(:, 4:6), 2, 2);
acc_sca = nonzeros(acc_sca);
[h,f] = hist(acc_sca, 100);
figure;
semilogy(f./std(acc_sca),h./trapz(f./std(acc_sca),h),'bo');
PDF = [h;f];
end

