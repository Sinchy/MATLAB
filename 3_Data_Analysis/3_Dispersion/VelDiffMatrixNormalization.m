function [tn_series, vel_diff_n, veldiff_matrix_nn] = VelDiffMatrixNormalization(veldiff_matrix, IS)
%disp_rate: m^2/s^3
%veldiff_matrix: m^2/s^2
%IS:mm

IS(IS == 0) = [];
r0 = mean(IS);

%     S = interp1(struct(:,1), struct(:,2), r0) + 2 * interp1(struct(:,1), struct(:,3), r0);
%     S = interp1(struct(:,1), struct(:,2), r0) * 11/3 / (4/3);
%     disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
S = mean(nonzeros(veldiff_matrix(:, 1)));
disp_rate = (S / ((41)^.5/3 * 2.1)) ^ (3/2) / (r0 /1e3) ;
t0 = CalT0(disp_rate, r0);

%     Vn = vel_diff / (S);
veldiff_matrix_n = veldiff_matrix/S;
% Rn = R / (S);

%% Interporate matrix using normalized time
len_time = length(nonzeros(sum(veldiff_matrix_n)));
% tn = (1:len_time)/4000/t0; % time series for the data set

t_max_n = (len_time - 1) / 4000 / t0;
time_inteval = 0.02; % fixed the interval
tn_series = 0 : time_inteval : t_max_n; % universal time series for all data sets

num_pairs = size(veldiff_matrix_n, 1);
len_time_n = length(tn_series);
veldiff_matrix_nn = zeros(num_pairs, len_time_n);
for i = 1 : num_pairs
    veldiff_vec = nonzeros(veldiff_matrix_n(i, 1:len_time))';
    vec_len = length(veldiff_vec);
    t_n = (0:vec_len - 1) / 4000 / t0;
    t_nn = 0 : time_inteval : (vec_len - 1) / 4000 / t0;
    vec_len_n = length(t_nn);
    if length(t_nn) > 1
        veldiff_matrix_nn(i, 1:vec_len_n) = interp1(t_n, veldiff_vec, t_nn);
    else
        veldiff_matrix_nn(i, 1) = veldiff_vec(1);
    end
    
end

% len = size(veldiff_matrix_n, 2);
vel_diff_n = zeros(len_time_n, 1); 
for i = 1 : len_time_n
    disp = nonzeros(veldiff_matrix_nn(:, i));
    if ~isempty(disp)
        vel_diff_n(i) = mean(disp);
%         r(i) = mean(disp_r);
%         [cn, cr] = hist(disp / mean(disp) , 10.^[-3:0.1:3]);
% 
%         vel_diff(i) = MeanOfcertainProbability(cn, cr, 0.6) * mean(disp);
    end
end
vel_diff_n = nonzeros(vel_diff_n);
% tn = (1:length(vel_diff_n))/4000/t0;
    
% tn = (1:length(R))/4000;
end

