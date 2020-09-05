% function [r_bin,u_square_mean, r,vel_square] = MSVelFromDispersion(disp_matrix, IS)
function [vel_square] = MSVelFromDispersion(disp_matrix)

[num_pair, num_frame] = size(disp_matrix);
% r = zeros(num_pair * num_frame, 1);
% vel_square = zeros(num_pair * num_frame, 1);
vel_square = zeros(num_pair , num_frame);
% num_point = 0;
for i = 1 : num_pair
    disp = nonzeros(disp_matrix(i,:));
    if length(disp) < 2
        continue;
    end
%     D = disp .^ .5 + IS(i);
    v_square = (disp(2:end) .^ .5 - disp(1:end-1) .^ .5) .^2 / 1e6 / (1/4000) ^2; 
    n_p = length(v_square);
%     r(num_point + 1: num_point + n_p) = D(2:end);
%     vel_square(num_point + 1: num_point + n_p) = v_square;
    vel_square(i, 1:n_p) = v_square;
%     num_point = num_point + n_p;
end
% r = nonzeros(r);
% vel_square = nonzeros(vel_square);
% 
% r_bin = 10.^[-1:.1:2];
% [c_num,c_lin]=histc(r,r_bin);
% hasdata = all(c_lin>0, 2);
% u_sum  = accumarray(c_lin(hasdata,:), vel_square(hasdata, :), [length(c_num)-1,1],@sum);
% u_sum(c_num(1:end-1) == 0) = [];
% r_bin(c_num == 0) = [];
% c_num(c_num == 0) = [];
% u_square_mean = u_sum./c_num;
% 
% figure; plot(r_bin, u_square_mean);
end

