function Q = QualityVelocityField(vel1, vel2)
[nx, ny, nz, ~] = size(vel1);
C1 = 0; C2 = 0; C3 = 0;
for i = 1 : nx
    for j = 1 : ny
        for  k = 1 : nz
            C1 = C1 + vel1(i, j, k, 1) * vel2(i, j, k, 1);
            C2 = C2 + vel1(i, j, k, 1) ^2;
            C3 = C3 + vel2(i, j, k, 1) ^2;
        end
    end
end
Q = C1 / (C2 * C3) ^ .5;
end

