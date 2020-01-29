function velocity_field_vec = GetVelocityField(tracks, num_grids_per_axis, view_length_per_axis, frame_no, frame_rate, dir)
tracks = tracks(tracks(:, 4) == frame_no, :);
spacing = view_length_per_axis / num_grids_per_axis;
velocity_field = zeros(num_grids_per_axis + 1, num_grids_per_axis + 1, num_grids_per_axis + 1, 3);
% assume the view area is symmetric on x y z
axis_min = - view_length_per_axis / 2 - spacing / 2;

for i = 1 : num_grids_per_axis + 1
    for j = 1 : num_grids_per_axis + 1
        for k = 1 : num_grids_per_axis + 1
            particle_in_grid = tracks(tracks(:, 1) >= axis_min + (i -1) * spacing & tracks(:, 1) < axis_min + i * spacing & ...
                tracks(:, 2) >= axis_min + (j -1) * spacing & tracks(:, 2) < axis_min + j * spacing & ...
                tracks(:, 3) >= axis_min + (k -1) * spacing & tracks(:, 3) < axis_min + k * spacing, :);
            if ~isempty(particle_in_grid)
                velocity_field(i, j, k, :) = mean(particle_in_grid(:, 6 : 8)) / frame_rate; % frame_rate is used to change the velocity into displacement
            end  
        end
    end
end

grid_position = - view_length_per_axis / 2: spacing : view_length_per_axis / 2;

[X,Y,Z] = meshgrid(grid_position, grid_position, grid_position);

figure
slice(X,Y,Z,reshape(velocity_field(:, :, :, 3), [num_grids_per_axis + 1, num_grids_per_axis + 1, num_grids_per_axis + 1]),0,0,0);
shading flat

%output txt
fileID = fopen([dir 'PredictiveField' num2str(frame_no - 1) '&' num2str(frame_no) '.txt'],'w');
for i = 1 : num_grids_per_axis + 1
    for j = 1 : num_grids_per_axis + 1
        for k = 1 : num_grids_per_axis + 1
            fprintf(fileID, '%6.4f,',velocity_field(i, j, k, :));
        end
    end
end
% 
% velocity_on_grid = zeros(num_grids_per_axis + 1, num_grids_per_axis + 1, num_grids_per_axis + 1, 3);
% 
% for i = 2 : num_grids_per_axis
%     for j = 2 : num_grids_per_axis
%         for k = 2 : num_grids_per_axis
%             pos = [axis_min + (i -1) * spacing, axis_min + (j -1) * spacing, axis_min + (k -1) * spacing];
%              for n = 1 : 3
%                  velocity_on_grid(i, j, k, n) = interp3(X, Y, Z, reshape(velocity_field(:, :, :, n), [num_grids_per_axis, num_grids_per_axis, num_grids_per_axis]), pos(1), pos(2), pos(3));
%              end
%         end
%     end
% end
% 
% grid_position = - view_length_per_axis / 2  : spacing : view_length_per_axis / 2;
% 
% figure
% [X,Y,Z] = meshgrid(grid_position, grid_position, grid_position);
% slice(X,Y,Z,reshape(velocity_on_grid(:, :, :, 1), [num_grids_per_axis + 1, num_grids_per_axis + 1, num_grids_per_axis + 1]),0,0,0);
% shading flat
velocity_field_vec = zeros((num_grids_per_axis + 1) ^ 3, 3);
for i = 1 : num_grids_per_axis + 1
    for j = 1 : num_grids_per_axis + 1
        for k = 1 : num_grids_per_axis + 1
            velocity_field_vec((i -1) * (num_grids_per_axis + 1) ^ 2 + (j -1) * (num_grids_per_axis + 1) + k, :) = velocity_field(i, j, k, :);
        end
    end
end
x = 1 : num_grids_per_axis + 1;
[X, Y, Z] = meshgrid(x,x,x);
X = reshape(X,[(num_grids_per_axis + 1)^3,1]);
Y = reshape(Y,[(num_grids_per_axis + 1)^3,1]);
Z = reshape(Z,[(num_grids_per_axis + 1)^3,1]);
grid_position = [X Y Z];
grid_position = sortrows(grid_position, 2);
grid_position = sortrows(grid_position, 1);
figure;
%velmag = vecnorm(reshape(velvec(1, : , :), [num_grid, 3]), 2, 2);
%quiver3(grid_position(:, 1), grid_position(:, 2), grid_position(:, 3), velvec(1, :, 1)'./ velmag,  velvec(1, :, 2)' ./ velmag,  velvec(1, :, 3)' ./ velmag);
quiver3(grid_position(:, 1), grid_position(:, 2), grid_position(:, 3), velocity_field_vec(:, 1),  velocity_field_vec(:, 1),  velocity_field_vec(:, 1));
end

