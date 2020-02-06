function data = MyReshapeTracks(file_path, num_particle)
data = load(file_path);
num_points = size(data, 1);
num_frame = num_points / num_particle;
frame_trID = ones(num_points, 2);
for i = 1 : num_frame
    frame_trID((i -1) * num_particle + 1 : i * num_particle, 1) = i;
    frame_trID((i -1) * num_particle + 1 : i * num_particle, 2) = (1 : num_particle)';
end
data(:, 7:8) = frame_trID;
data = data(:, [1 2 3 7 8 4 5 6]);
end