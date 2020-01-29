function error = GetTriangulationErrorForATrack(track,camParaCalib)
for i = 1 : size(track,1)
    pos3D = track(i, 1:3);
    pos2D(1:2) = calibProj(camParaCalib(1), pos3D);
    pos2D(3:4) = calibProj(camParaCalib(2), pos3D);
    pos2D(5:6) = calibProj(camParaCalib(3), pos3D);
    pos2D(7:8) = calibProj(camParaCalib(4), pos3D);
    [position3D, error(i)] = Triangulation(camParaCalib, pos2D);
end
end

