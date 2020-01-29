function Output2Dcenters(tracks, camParaCalib, file_path)
for i = 1 : 4
    particles = tracks(tracks(:, 4) == i, :);
    ind = zeros(size(particles, 1), 4);
    for j = 1 : 4
        X2D = calibProj(camParaCalib(j), particles(:, 1:3));
        ind(:, j) = X2D(:,1) < 2 | X2D(:,1) >1022 | X2D(:,2) < 2 | X2D(:,2) >1022;
    end
    untrackable = sum(ind') >= 1; 
    particles(untrackable', :) = []; % delete particles which don't show up on at least one camera
    for cam = 1 : 4
        pos2D = calibProj(camParaCalib(cam), particles(:, 1 : 3));
        pos2D = reshape(pos2D', [size(pos2D, 1) * 2, 1]);
        fileID = fopen([file_path 'cam' num2str(cam) '/' 'cam' num2str(cam) 'frame0000'  num2str(i) '.txt'], 'w');
        fprintf(fileID, '%6.4f,', pos2D);
    end
end
end

