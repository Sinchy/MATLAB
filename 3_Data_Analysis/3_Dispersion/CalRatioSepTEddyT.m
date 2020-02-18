function [gama, IS] = CalRatioSepTEddyT(tracks, pairs)
%calculate the ratio of the separation time scale to the eddy turn over
%time scale
% file = matfile(filepath);
num_pairs = size(pairs, 1);
gama = zeros(num_pairs, 1);
frame_rate = 4000;
disp_rate = .16;
IS = zeros(num_pairs, 1);

for i = 1 : num_pairs
%     i
%     trackA = data_map.Data.eulrot(data_map.Data.eulrot(:,5) == pairs(i, 1), :);
%     trackB = data_map.Data.eulrot(data_map.Data.eulrot(:,5) == pairs(i, 2), :);
    trackA = tracks(tracks(:,5) == pairs(i, 1), :);
    trackB = tracks(tracks(:,5) == pairs(i, 2), :);
    trackA(trackA(:, 4) < pairs(i, 3), :) = [];
    trackB(trackB(:, 4) < pairs(i, 3), :) = [];
    if size(trackA, 1) < 2 || size(trackB, 1) < 2 
        continue;
    end
    r0 = norm(trackA(1, 1:3) - trackB(1, 1:3));
    r1 = norm(trackA(2, 1:3) - trackB(2, 1:3));
    sep_vel = (r1 - r0) / (1 / frame_rate) / 1000; % unit: m/s
    t_sep = sep_vel^2 / disp_rate;
    t_eddy = ((r0 / 1000) ^2 / disp_rate) ^ (1/3);
    gama(i) = t_sep / t_eddy;
    IS(i) = r0;
end
end

