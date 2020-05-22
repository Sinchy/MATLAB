function [vel_diff, veldiff_matrix] = CalMeanFromTimeMatrix(veldiff_matrix, order)
if ~exist('order', 'var')
    order = 2;
end
veldiff_matrix = veldiff_matrix.^(order/2);
[~, len] = size(veldiff_matrix);
vel_diff = zeros(len, 1); 
% r = zeros(len, 1); 
for i = 1 : len
    disp = nonzeros(veldiff_matrix(:, i));
%     disp_r = nonzeros(r_matrix(:, i));
    if ~isempty(disp)
        vel_diff(i) = mean(disp);
%         r(i) = mean(disp_r);
%         [cn, cr] = hist(disp / mean(disp) , 10.^[-3:0.1:3]);
% 
%         vel_diff(i) = MeanOfcertainProbability(cn, cr, 0.6) * mean(disp);
    end
end
vel_diff = nonzeros(vel_diff);
end

