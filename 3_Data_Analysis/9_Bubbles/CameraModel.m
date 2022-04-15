function r_i = CameraModel(pos, r_p, camParaCalib, x_ca, y_ca, z_ca, do)
% cam_axis is the direction of camera, do is measured from the location of
% lens
% calculate camera magnification
f = 180;
Da = f / 32;
cam_center = camParaCalib.Tinv';
cam_axis_direction =[x_ca, y_ca, z_ca] / norm([x_ca, y_ca, z_ca]); 
% pick 2 points on the  focus plane
p0 = cam_center + cam_axis_direction * do;
p1 = [(-  cam_axis_direction(2) -  cam_axis_direction(3)) /  cam_axis_direction(1) + p0(1), p0(2) + 1, p0(3) + 1 ];
p1_2D = calibProj_Tsai(camParaCalib, p1);
p0_2D = calibProj_Tsai(camParaCalib, p0);
dist_2D = norm(p1_2D - p0_2D) * 0.02;
dist_3D = norm(p1 - p0);
M = dist_2D / dist_3D;

for i = 1 : size(pos, 1)
    d_p = dot( pos(i, :) - cam_center, cam_axis_direction);
    r_i(i) = ((M * r_p * 2) ^ 2 + (M * Da * (d_p - do) / d_p)^2) ^.5 / 2;
end
end

