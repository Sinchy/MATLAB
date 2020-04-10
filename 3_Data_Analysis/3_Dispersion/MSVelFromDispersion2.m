function [r_bin,u_square_mean, r,vel_square] = MSVelFromDispersion2(data_map, pairs, range)

% [num_pair, num_frame] = size(disp_matrix);
% r = zeros(num_pair * num_frame, 1);
% vel_square = zeros(num_pair * num_frame, 1);
% num_point = 0;
% for i = 1 : num_pair
%     disp = nonzeros(disp_matrix(i,:));
%     if length(disp) < 2
%         continue;
%     end
%     D = disp .^ .5 + IS(i);
%     v_square = (disp(2:end) .^ .5 - disp(1:end-1) .^ .5) .^2 / 1e6 / (1/4000) ^2; 
%     n_p = length(v_square);
%     r(num_point + 1: num_point + n_p) = D(2:end);
%     vel_square(num_point + 1: num_point + n_p) = v_square;
%     num_point = num_point + n_p;
% end
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);
num_pairs = size(pairs, 1);
num_frame = range(2) - range(1) + 1;
r = zeros(num_pairs * num_frame, 1);
vel_square = zeros(num_pairs * num_frame, 1);
num_point = 0;
for i = 1 : num_pairs
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    if len < range(1)
        continue;
    end
    if len < range(2)
        last_index = len;
    else
        last_index = range(2);
    end
    direction = track2(range(1):last_index, 1:3) - track1(range(1):last_index, 1:3);
    D = vecnorm(direction, 2, 2);
    direction = direction ./ D;
    v_square = dot(track2(range(1):last_index, 6:8) - track1(range(1):last_index, 6:8), direction, 2) .^ 2 / 1e6;
    n_p = length(v_square);
    r(num_point + 1: num_point + n_p) = D;
    vel_square(num_point + 1: num_point + n_p) = v_square;
    num_point = num_point + n_p;
end

r = nonzeros(r);
vel_square = nonzeros(vel_square);

r_bin = 10.^[-1:.1:2];
[c_num,c_lin]=histc(r,r_bin);
hasdata = all(c_lin>0, 2);
u_sum  = accumarray(c_lin(hasdata,:), vel_square(hasdata, :), [length(c_num)-1,1],@sum);
u_sum(c_num(1:end-1) == 0) = [];
r_bin(c_num == 0) = [];
c_num(c_num == 0) = [];
u_square_mean = u_sum./c_num;

red = [1, 0, 0];
pink = [0.00,0.00,1.00];
colors_p = [linspace(red(1),pink(1),10)', linspace(red(2),pink(2),10)', linspace(red(3),pink(3),10)'];


plot(r_bin, u_square_mean, 'Color', colors_p(5,:), 'LineWidth', 2, 'Marker', 'o');
end

