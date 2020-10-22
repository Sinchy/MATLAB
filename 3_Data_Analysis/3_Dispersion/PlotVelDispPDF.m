function [density,X,Y] = PlotVelDispPDF(sep_matrix, vel_matrix, MINXY, MAXXY)

% [x, y] = size(disp_matrix);
% disp = zeros(x*y, 1);
% [x, y] = size(vel_matrix);
% vel = zeros(x*y, 1);
% 
% index1 = 1;
% for i = 1 : x
%     dp = [IS(i); nonzeros(disp_matrix(i, :)) + IS(i)];
%     index2 = index1 + length(dp) - 1;
%     disp(index1 : index2) = dp;
%     vl = nonzeros(vel_matrix(i, :));
%     vel(index1 : index2) = vl;
%     index1 = index2 + 1;
% end
disp = nonzeros(sep_matrix(:));
mean_disp = mean(disp);
std_disp = std(disp);
vel = nonzeros(vel_matrix(:));
mean_vel = mean(vel);
std_vel = std(vel);

addpath D:\0.Code\MATLAB\0_Math
figure
data = [disp vel];
[~,density,X,Y]=kde2d(data, 2^8, MINXY, MAXXY);
 % plot the data and the density estimate
 contour3(X,Y,density,50), hold on
 

end

