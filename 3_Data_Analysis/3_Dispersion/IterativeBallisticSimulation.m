function [R, R_gamma, disp_matrix, track_package, gamma_mark] = IterativeBallisticSimulation(disp_rate, initial_separate, integral_time)
%disp_rate: m^2/s^3
disp_rate = disp_rate * 1e6;
initial_separate(initial_separate==0) = [];

addpath C:\Users\ShiyongTan\Documents\Code\MATLAB\0_Math;

gamma_thred = 0.1;
alpha = 0.05;
% alpha = 0.01;
C = 2.1;
[num_pair, frame] = size(initial_separate);
% separate_1 = initial_separate;
% set up PDF for dissipation rate
% r = min(initial_separate) * .1; % fix the r as a constant which is one order of magnitude smaller
% r = 0.05; % kolmogorov length
% sigma_disp = sqrt(0.25 * log(integral_length / r));
% mu_disp = 1/2 * sigma_disp ^ 2;

track_package = cell(num_pair, 1);
end_time = integral_time * 3;

 dt = 1/4000; % sample time
% dt = 5/1e3;
disp_matrix = zeros(num_pair, ceil(end_time / dt));
gamma = zeros(num_pair, 1);
gamma_mark = zeros(num_pair, 1);
integral_length = (integral_time * disp_rate^(1/3))^(3/2);
r0 = mean(initial_separate(:,1));
for i = 1 : num_pair
    if initial_separate(i, 1) < integral_length
        sigma_disp = sqrt(0.25 * log(integral_length / initial_separate(i, 1)));
%         sigma_disp = sqrt(0.25 * log(integral_length / r0));
        mu_disp = 1/2 * sigma_disp ^ 2;
        disp = disp_rate * randraw('lognorm', [mu_disp, sigma_disp], 1);
% disp = disp_rate;
    else
        disp = disp_rate;
    end
%     disp = disp_rate;
    struct = 11/3 * C * (disp * initial_separate(i, 1)) ^ (2/3);
%     struct =  C * (disp * initial_separate(i, 1)) ^ (2/3);
    t0 = alpha * struct / (2 * disp);
    track = zeros(ceil(end_time / t0), 2);
    t = 0;
    j = 2;
    track(1, 1:2) = [0 initial_separate(i)];
    for k = 2 : frame
        track(k, 1:2) = [t initial_separate(i, k)];
        t = t + dt;
        j = j + 1;
    end
%     track(2, 1) = t0;
%     track(2, 2) = (track(1,2) ^ 2 + struct * t0 ^ 2)^.5;
    
%     j = 2;
    
%     track = zeros(ceil(integral_time / t0 + t0 / dt), 2);
%     track(1, 1:2) = [0 initial_separate(i)];
%     j = 2;
%     t = 0;
% %     calculation for t smaller than t0
%     while (t < t0)
%         sigma_disp = sqrt(0.25 * log(integral_length / track(j - 1, 2)));
%         mu_disp = 1/2 * sigma_disp ^ 2;
%          disp = disp_rate * randraw('lognorm', [mu_disp, sigma_disp], 1);
% %          disp = disp_rate;
%         struct = C * (disp * track(j - 1, 2)) ^ (2/3);
% %          struct = C * (disp * track(1, 2)) ^ (2/3);
%          tk = dt;
%         track(j, 1) = t + tk;
%         track(j, 2) = (track(j - 1,2) ^ 2 + struct * (t0 * tk))^.5;
% %         track(j, 2) = track(j - 1,2) + struct^.5/2 * tk;
%         t = t + tk;
%         j = j + 1;
%     end
    % for t larger than t0 and smaller than end time
    while (t < end_time)
        if track(j - 1, 2) < integral_length
            sigma_disp = sqrt(0.25 * log(integral_length / track(j - 1, 2)));
%              sigma_disp = sqrt(0.25 * log(integral_length / r0));
            mu_disp = 1/2 * sigma_disp ^ 2;
             disp = disp_rate * randraw('lognorm', [mu_disp, sigma_disp], 1);
%              if j > 2 disp = disp_rate;end
        else
            disp = disp_rate;   
        end
%         disp = disp_rate;
        struct = 11/3 * C * (disp * track(j - 1, 2)) ^ (2/3);
%         struct =  C * (disp * track(j - 1, 2)) ^ (2/3);
        tk = alpha * struct / (2 * disp);
        track(j, 1) = t + tk;
        track(j, 2) = (track(j - 1,2) ^ 2 + struct * tk ^ 2)^.5;
%         track(j, 2) = track(j - 1,2) + struct^.5/2 * tk;

%         if j == 2
%             point2 = interp1(track(1:2,1), track(1:2,2), dt);
%             sep_vel = (point2 - track(1,2)) / dt; % unit: mm/s
%             t_sep = sep_vel^2 / disp_rate;
%             t_eddy = (track(1,2) ^2 / disp_rate) ^ (1/3);
%             gamma(i) = t_sep / t_eddy;
% %             if gamma(i) < gamma_thred
% %                 gamma_mark(i) = 1;
% %             end
%             if gamma(i) > 0.1
%                 t = t - tk;
%                 j = j - 1;
%             end
%         end
% 
        t = t + tk;
        j = j + 1;
        

    end
    track(j:end, :) = [];
    track_reorg = interp1(track(:,1), track(:,2), 0:dt:end_time, 'linear');
    % gamma check
    sep_vel = (track_reorg(2) - track_reorg(1)) / dt; % unit: mm/s
    t_sep = sep_vel^2 / disp_rate;
    t_eddy = (track_reorg(1) ^2 / disp_rate) ^ (1/3);
%     t_sep = sep_vel^2 / 1.6e5;
%     t_eddy = (track_reorg(1,2) ^2 / 1.6e5) ^ (1/3);
    gamma(i) = t_sep / t_eddy;
    if gamma(i) < gamma_thred
        gamma_mark(i) = 1;
    end
    
    disp_matrix(i, 1:length(track_reorg) - 1) = (track_reorg(2:end) - track_reorg(1)).^2;
    track_package{i} = track;
end

len = size(disp_matrix, 2);
R = zeros(len, 1);
R_gamma = zeros(len, 1);
disp_matrix_gamma = disp_matrix(gamma_mark == 1, :);
for i = 1 : len
    disp = nonzeros(disp_matrix(:, i));
    disp_gamma = nonzeros(disp_matrix_gamma(:, i));
    if ~isempty(disp)
        R(i) = mean(disp);
        R_gamma(i) = mean(disp_gamma);
    end
end
R = nonzeros(R);
R_gamma = nonzeros(R_gamma);
end

