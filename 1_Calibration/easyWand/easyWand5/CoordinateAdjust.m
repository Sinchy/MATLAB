function [camParaCalib_new, rot_matrix] = CoordinateAdjust(camParaCalib)
CameraDistribution(camParaCalib);

cam_id = str2double(inputdlg('Which camera does X axis point to?', 'Axis direction'));

incline_angle = str2double(inputdlg('Incline angle of this camera relative to X axis:(positive as anticlockwise, in degree)', 'Incline angle'));

% position of the camera
cow=camParaCalib(cam_id).R\([0 0 0]' - camParaCalib(cam_id).T);
% angle in XZ plane
angleXZ = Angle([0, 0, 1], [cow(1), 0, cow(3)]);
rot_XZ = angleXZ;

angleYZ = Angle([0, 0, 1], [0, cow(2), cow(3)]);
rot_YZ = incline_angle * pi / 180 - angleYZ ; 


% rotation adjust
rot_matrix = eul2rotm([0 rot_XZ rot_YZ]); % sequence: Z, Y, X

% get the new camera position after rotation on XZ plane, in order to get
% the other rotation on YZ plane
% camParaCalib_ref = camParaCalib(cam_id);
% camParaCalib_ref.R = rot_matrix \ camParaCalib_ref.R;
% T = [[camParaCalib_ref.R camParaCalib_ref.T]; [0 0 0 1]];
% Tinv = T^(-1);
% camParaCalib_ref.Rinv = Tinv(1:3, 1:3);
% camParaCalib_ref.Tinv = Tinv(1:3, 4);
% cow_rot1=camParaCalib_ref.R\([0 0 0]' - camParaCalib_ref.T);
% 
% angleYZ = Angle([0, 0, 1], [0, cow_rot1(2), cow_rot1(3)]);
% rot_YZ = incline_angle * pi / 180 - angleYZ ; 
% 
% rot_matrix = eul2rotm([0 0 rot_YZ]) * rot_matrix;
camParaCalib_new = camParaCalib;
for i = 1 :  size(camParaCalib, 1)
    % Xc = RXw+T
    % Xc = R*R'^-1*R'Xw+T = R_new * Xw'+T_new, therefore: R_new = R*R'^-1, T_new = T 
    camParaCalib_new(i).R = rot_matrix \ camParaCalib(i).R;
    T = [[camParaCalib_new(i).R camParaCalib_new(i).T]; [0 0 0 1]];
    Tinv = T^(-1);
    camParaCalib_new(i).Rinv = Tinv(1:3, 1:3);
    camParaCalib_new(i).Tinv = Tinv(1:3, 4);
end
CameraDistribution(camParaCalib_new);
end

function angle = Angle(u, v)
CosTheta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
angle = real(acos(CosTheta));
end

