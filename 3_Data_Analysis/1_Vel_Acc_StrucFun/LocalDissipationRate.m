function [disp, location] = LocalDissipationRate(tracks)
filter_length = 10; % 2mm
max_x = max(tracks(:, 1)); min_x = min(tracks(:, 1));
max_y = max(tracks(:, 2)); min_y = min(tracks(:, 2));
max_z = max(tracks(:, 3)); min_z = min(tracks(:, 3));
domain_size = [min_x max_x; min_y max_y;min_z max_z;];
num_grid = floor((domain_size(:,2) - domain_size(:,1)) / filter_length);
num_grid = num_grid(1) * num_grid(2) * num_grid(3);

addpath D:\0.Code\MATLAB\3_Data_Analysis\3_Dispersion
VG = Coarse_grained_velocity_gradient;


[frame_no, ~, ~] = unique(tracks(:,4),'first');
num_frame = 10000; % number of frames to calculate SF
frame_select = frame_no(randperm(numel(frame_no), num_frame)); % randomly select frames
disp = zeros(num_grid, num_frame);
h = waitbar(0, 'processing...');
for j = 1 : num_frame
     waitbar( j / num_frame, h, 'processing...');
particles = tracks(tracks(:,4) == frame_select(j), :);
du_dx_field = VG.Cal_CGVG_field2(particles, filter_length, domain_size);
location = du_dx_field(:, 1:3);
num_grid = size(du_dx_field, 1);
for i = 1 :  num_grid
    du_dx = du_dx_field(i, 4:12);
    if sum(du_dx) == 0
        disp(i, j) = 0;
        continue;
    end
    du_dx = reshape(du_dx, 3, 3);
    strain = VG.StrainRate(du_dx);
    [~, D] = eig(strain, 'vector');
    lambda = min(D);
    disp(i, j) = ((lambda * filter_length / 1e3) ^2 / 2.13) ^ (3/2) / (filter_length / 1e3);
end
end

end

