% Generate two points where their distance is fixed: 10mm
n_pt = 1000;
pt1 = rand(n_pt, 3) * 20 - 10;
% pt2 = rand(50, 2) * 20 - 10;
pt2 = zeros(n_pt, 3);
%% determine the second point
i = 1;
while (i <= n_pt)
    pt = rand(1, 2) * 20 - 10;
    d0 = (pt1(i, 1) - pt(1)) ^ 2 + (pt1(i, 2) - pt(2)) ^ 2;
    dz = 10^2 - d0;
    if dz < 0
        continue;
    end
    z1 = dz ^ .5 + pt1(i, 3);
    if abs(z1) < 20
        pt2(i,:) = [pt z1];
        i = i + 1;
        continue;
    end
    z2 = -dz ^ .5 + pt1(i, 3);
    if abs(z2) < 20
        pt2(i,:) = [pt z1];
        i = i + 1;
        continue;
    end
end
nz = 0;
pt1_cam1 = calibProj_Tsai(camParaCalib(1), pt1) +rand(n_pt, 2) * nz;
pt2_cam1 = calibProj_Tsai(camParaCalib(1), pt2) +randn(n_pt, 2)* nz;
pt1_cam2 = calibProj_Tsai(camParaCalib(2), pt1) +randn(n_pt, 2)* nz;
pt2_cam2 = calibProj_Tsai(camParaCalib(2), pt2) +randn(n_pt, 2)* nz;
pt1_cam3 = calibProj_Tsai(camParaCalib(3), pt1) +randn(n_pt, 2)* nz;
pt2_cam3 = calibProj_Tsai(camParaCalib(3), pt2) +randn(n_pt, 2)* nz;
pt1_cam4 = calibProj_Tsai(camParaCalib(4), pt1) +randn(n_pt, 2)* nz;
pt2_cam4 = calibProj_Tsai(camParaCalib(4), pt2) +randn(n_pt, 2)* nz;
wandpts = [pt1_cam1 pt1_cam2  pt1_cam3 pt1_cam4 pt2_cam1  pt2_cam2  pt2_cam3  pt2_cam4];
ind = sum(wandpts(:, 1:2:2*8) < 0 | wandpts(:, 1:2:2*8)  > 1280 | ...
    wandpts(:, 2:2:2*8) < 0 | wandpts(:, 2:2:2*8)  > 800, 2) > 0;
wandpts(ind, :) = [];
pt1(ind, :) = [];
pt2(ind, :) = [];

%% axis

axis = [0 0 0; 1 0 0; 0 1 0; 0 0 1];
axis_imag1 = calibProj_Tsai(camParaCalib(1), axis);
axis_imag2 = calibProj_Tsai(camParaCalib(2), axis);
axis_imag3 = calibProj_Tsai(camParaCalib(3), axis);
axis_imag4 = calibProj_Tsai(camParaCalib(4), axis);

axispts = [axis_imag1 axis_imag2 axis_imag3 axis_imag4];

