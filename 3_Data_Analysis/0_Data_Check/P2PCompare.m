% for i = 1 : 4
%     i
%     original = tracks(tracks(:,4) == i, :);
%     particles = ReadParticles([file_path, num2str(i) '.txt']);
%     [ghost_percent(i), ~ ] = GhostCheck(original, particles);
% end


for i = 51 : 100
    i
     original = tracks(tracks(:,4) == i, :);
    tracked = tracks_STB(tracks_STB(:, 4) == i, :);
    candidates = ReadParticles([file_path, num2str(i) '.txt']);
    particles = [candidates; tracked(:, 1:3)];
%     image_path = '/media/Share2/Public/Shiyong_Backup/Synthetic_data/SD50000/';
    [ghost_percent(i), ~] = GhostCheck(original, particles);
%     ghost_percent(i) = GhostCheck(original, tracked);
end