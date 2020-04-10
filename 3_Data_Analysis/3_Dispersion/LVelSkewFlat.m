function [S, F] = LVelSkewFlat(data_map, pairs, t)
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

num_pair = size(pairs, 1);
num_t = length(t);
Lvel = zeros(num_pair, num_t);
pool = parpool(11);
parfor i = 1 : num_t
    t_f = round(t(i) * 4000); %switch time into frame
    for j = 1 : num_pair
        track1 = tracks(tracks(:,5) == pairs(j, 1), :);
        track2 = tracks(tracks(:,5) == pairs(j, 2), :);
        track1 = track1(track1(:,4) >= pairs(j, 3), :);
        track2 = track2(track2(:,4) >= pairs(j, 3), :);
        len1 = size(track1, 1);
        len2 = size(track2, 1);
        len = min(len1, len2);
        if len < t_f 
            continue;
        end
        dr = track1(t_f, 1:3) - track2(t_f, 1:3);
        dr = dr / norm(dr);
        vel = track1(t_f, 6:8) - track2(t_f, 6:8);
        Lvel(j, i) = dot(vel, dr);
%         Lvel(j, i) = dot(track1(i, 6:8), dr) * dot(track2(i, 6:8), dr);
    end
end
delete(pool);
% Lvel_fluct_std = zeros(num_pair, num_t);

for i = 1 : num_t
%    Lvel_mean = mean(nonzeros(Lvel(:, i))); 
%    Lvel_fluct = Lvel(:, i) - Lvel_mean;
%    Lvel_var = mean(Lvel_fluct.^2) ^ .5;
%    S(i) = mean(Lvel_fluct .^ 3) / Lvel_var ^ 3;
%    F(i) = mean(Lvel_fluct .^ 4) / Lvel_var ^ 4;
    S(i) = skewness(nonzeros(Lvel(:,i)), 0);
    F(i) = kurtosis(nonzeros(Lvel(:,i)), 0);
end

end

