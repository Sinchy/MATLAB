function OutPutParticles(tracks, file_path)
for i = 1 : 4
    particles = tracks(tracks(:, 4) == i, 1 : 3);
    particles = reshape(particles', [size(particles, 1) * 3, 1]);
    fileID = fopen([file_path 'pos3Dframe' num2str(i) '.txt'], 'w');
    fprintf(fileID, '%6.4f,', particles);
    fclose(fileID);
end
end

