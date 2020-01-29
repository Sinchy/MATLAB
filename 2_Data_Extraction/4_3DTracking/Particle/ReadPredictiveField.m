function [velvec, grid_position] = ReadPredictiveField(file_path)
for i = 0 : 2
    fileID = fopen([file_path 'PredictiveField' num2str(i) '&' num2str(i + 1 ) '.txt'], 'r');
    formatspec = '%f,';
    vel = fscanf(fileID, formatspec);
    fclose(fileID);
    vel = reshape(vel, [3 size(vel,1)/3]);
    vel = vel';
    % remove some outlier
    velmag = vecnorm(vel, 2, 2);
    [~,TF] = rmoutliers(velmag);
    vel(TF == 1, :) = 0; % make the outliers 0
    velvec(i + 1, :, :) = vel;
end



num_grid = size(velvec, 2);
num_grid_per_axis = round(num_grid ^ (1/3));
x = 1 : num_grid_per_axis;
[X, Y, Z] = meshgrid(x,x,x);
X = reshape(X,[num_grid_per_axis^3,1]);
Y = reshape(Y,[num_grid_per_axis^3,1]);
Z = reshape(Z,[num_grid_per_axis^3,1]);
grid_position = [X Y Z];
grid_position = sortrows(grid_position, 2);
grid_position = sortrows(grid_position, 1);
figure;
%velmag = vecnorm(reshape(velvec(1, : , :), [num_grid, 3]), 2, 2);
%quiver3(grid_position(:, 1), grid_position(:, 2), grid_position(:, 3), velvec(1, :, 1)'./ velmag,  velvec(1, :, 2)' ./ velmag,  velvec(1, :, 3)' ./ velmag);
quiver3(grid_position(:, 1), grid_position(:, 2), grid_position(:, 3), velvec(1, :, 1)',  velvec(1, :, 2)',  velvec(1, :, 3)');
figure;
quiver3(grid_position(:, 1), grid_position(:, 2), grid_position(:, 3), velvec(2, :, 1)',  velvec(2, :, 2)',  velvec(2, :, 3)');
figure;
quiver3(grid_position(:, 1), grid_position(:, 2), grid_position(:, 3), velvec(3, :, 1)',  velvec(3, :, 2)',  velvec(3, :, 3)');
end

