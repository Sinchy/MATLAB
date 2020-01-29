% num_particle = size(data, 1);
% frame = zeros(num_particle, 1);
% for i = 1 : num_particle
%     ind = find(particles_cam1(:, 1) == data(i, 4) & particles_cam1(:, 2) == data(i, 5));
% end

num_particle = size(data, 1);
new_data = data;
for i = 1 : num_particle
    new_data(i, 1:3) = Triangulation(camParaCalib, new_data(i, 4:11));
end