function [PDF, disp_speed] = GetDispersionSpeedPDF(disp_matrix, t)
disp1 = disp_matrix(:, t);
disp2 = disp_matrix(:, t + 1);
%delete tracks endded at t + 1
ind = disp2 == 0;
disp1(ind) = [];
disp2(ind) = [];
disp_speed = (log(disp2) - log(disp1)) / (log(t + 1) - log(t));
[counts,centers] = hist(disp_speed, 50);
prob = counts / sum(counts);
PDF = [prob', centers'];
end

