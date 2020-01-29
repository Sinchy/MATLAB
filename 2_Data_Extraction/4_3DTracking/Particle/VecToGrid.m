function vel = VecToGrid(velocity_field)
num_grid = size(velocity_field, 1);
num_grid_per_axis  = round(num_grid ^ (1/3));
for i = 1 : num_grid_per_axis
    for j = 1 : num_grid_per_axis
        for k = 1 : num_grid_per_axis
            vel(i, j, k, :) = velocity_field( (i - 1) * num_grid_per_axis ^ 2 + (j - 1) * num_grid_per_axis + k, :);
        end
    end
end

end

