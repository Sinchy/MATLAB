function [gamma_t, gamma_matrix, sep_matrix] = CalGammaMatrix(tracks, pairs)
num_pair = size(pairs, 1);
frame_rate = 4000;
disp_rate = .16;

len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
gamma_matrix = zeros(num_pair, len);
sep_matrix = zeros(num_pair, len);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    r0 = vecnorm(track1(1 : len - 1, 1:3) - track2(1 : len - 1, 1:3), 2, 2);
    r1 = vecnorm(track1(2 : len, 1:3) - track2(2 : len, 1:3), 2, 2);
    sep_vel = (r1 - r0) / (1 / frame_rate) / 1000; % unit: m/s
    t_sep = sep_vel.^2 / disp_rate;
    t_eddy = ((r0 / 1000) .^2 / disp_rate) .^ (1/3);
    gamma_matrix(i, 1 : len - 1) = t_sep ./ t_eddy;
    sep_matrix(i, 1 : len - 1) = r0;   
end

len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
gamma_t = zeros(len - 1, 1);
for i = 1 : len
    disp = nonzeros(gamma_matrix(:, i));
    if ~isempty(disp)
       gamma_t(i) = mean(disp);
    end
end
gamma_t = nonzeros(gamma_t);

end

