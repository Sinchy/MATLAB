track_ID = unique(disp_matrix2(:,5));
num_track = size(track_ID, 1);
slope = zeros(num_track, 1);
for i = 1 :num_track
    track1 = disp_matrix1(disp_matrix1(:, 5) == track_ID(i), :);
    track2 = disp_matrix2(disp_matrix2(:, 5) == track_ID(i), :);
    MSD1 = var(track1(:,12));
    MSD2 = var(track2(:,12));
    slope(i) = (log(MSD2) - log(MSD1))/(log(2) - log(1));
    i
end