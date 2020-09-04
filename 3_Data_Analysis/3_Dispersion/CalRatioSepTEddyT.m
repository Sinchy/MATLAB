function gamma = CalRatioSepTEddyT(data_map, pairs, IS, veldiff_matrix)
%calculate the ratio of the separation time scale to the eddy turn over
%time scale
% file = matfile(filepath);
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

num_pairs = size(pairs, 1);
gamma = zeros(num_pairs, 1);
frame_rate = 4000;

IS(IS == 0) = [];
r0 = mean(IS);

%     S = interp1(struct(:,1), struct(:,2), r0) + 2 * interp1(struct(:,1), struct(:,3), r0);
%     S = interp1(struct(:,1), struct(:,2), r0) * 11/3 / (4/3);
%     disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
S = mean(nonzeros(veldiff_matrix(:, 1)));
disp_rate = (S / ((41)^.5/3 * 2.1)) ^ (3/2) / (r0 /1e3) ;

% disp_rate = .16;
% IS = zeros(num_pairs, 1);

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
    gamma(i) = t_sep / t_eddy;
%     IS(i) = r0;
end
end

