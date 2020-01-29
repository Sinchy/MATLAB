function trackable = TrackableMark(particles, camParaCalib)
    ind = zeros(size(particles, 1), 4);
    for j = 1 : 4
        X2D = calibProj_Tsai(camParaCalib(j), particles(:, 1:3));
        ind(:, j) = X2D(:,1) < 2 | X2D(:,1) >1022 | X2D(:,2) < 2 | X2D(:,2) >1022;
    end
    trackable = sum(ind') < 1;
end

