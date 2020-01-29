M3D = Label_track_code;
for i = 1:16
    for j = 1:200
        if (M3D(i,j,1) == 0 && M3D(i,j,2) == 0 && M3D(i,j,3) == 0) continue; end
        M2D(j,:) = M3D(i,j,:);
    end
end