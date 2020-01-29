function diff = PixelSensitivity(camParaCalib)
point = [ 0 0 0 ];
for i = 1 : 4
   center((i - 1) * 2 + 1 : i * 2) = calibProj_Tsai(camParaCalib(i), point); 
end

% move one pixel in camera 1 
center(1) = center(1) + 1;
point_mov = Triangulation(camParaCalib, center);
diff = norm(point - point_mov);
end

