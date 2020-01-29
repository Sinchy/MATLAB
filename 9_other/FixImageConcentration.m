image_concentration = 12500;
DoF = 20;
%  N = 20000;
N1 = N;
N0 = 0;
E = N;

while (abs(E) > 100)
    particles = reshape(new_points_250(:, 1:N, 200), N, 3);
    result = GetSNR(particles, DoF, camParaCalib);
    E = image_concentration - result(1) - result(3);
    if E > 0
        N0 = N;
        N = round((N + N1) / 2);
    else
        N1 = N;
        N = round((N + N0) / 2);
    end
end
