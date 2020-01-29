function trackable = UntrackableNumPerFrame(tracks, CamParaCalib)
start_frame = min(tracks(:,4));
end_frame = max(tracks(:,4));
for i = start_frame :  end_frame
    particles = tracks(tracks(:,4) == i, :);
    ind = zeros(size(particles, 1), 4);
    for j = 1 : 4
        X2D = calibProj_Tsai(CamParaCalib(j), particles(:, 1:3));
        ind(:, j) = X2D(:,1) < 2 | X2D(:,1) >1022 | X2D(:,2) < 2 | X2D(:,2) >1022;
    end
    untrackable = sum(ind') >= 1;
    untrackable_num = sum(untrackable);
    trackable(i) = size(particles, 1) - untrackable_num;
end

end
