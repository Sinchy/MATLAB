function untrackable_mark = UntrackableMark(tracks, camParaCalib)
num_particle = size(tracks,1);
untrackable_mark = zeros( num_particle, 1);

for i = 1 : num_particle
    untrackable_num = 0;
    for j = 1 : 4
        X2D = calibProj_Tsai(camParaCalib(j),tracks(i, 1:3));
        xc = X2D(1); yc = X2D(2);
        if (xc < 2 || xc > 1022 || yc < 2 || yc > 1022) 
            untrackable_num = untrackable_num + 1;
        end
    end
    if untrackable_num > 1 
        untrackable_mark(i) = 1;
    end
end

for i = 1 : 250
    untrackable_num_frame(i) = sum(untrackable_mark(tracks(:,4) == i));
end
end