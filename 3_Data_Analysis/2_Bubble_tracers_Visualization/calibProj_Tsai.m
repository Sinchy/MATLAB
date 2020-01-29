function Xtest_proj = calibProj_Tsai(camParaCalib, Xtest3D, cam)
% Use the calibrated camera parameters to predict the particle position
% projected onto the image plane.
%
% inputs:
%   camParaCalib(cam)    --  calibrated camera parameters
%   Xtest3D         --  test particle coordinates in 3D world system
%
% output:
%   Xtest_proj      --  projected particle position on image plane (in
%   pixels)
%% Note that this is the second version: remove the iteration on k1, add kstar


%%

Xc = Xtest3D * (camParaCalib(cam).R)';
Xc(:,1) = Xc(:,1) + camParaCalib(cam).T(1);
Xc(:,2) = Xc(:,2) + camParaCalib(cam).T(2);
Xc(:,3) = Xc(:,3) + camParaCalib(cam).T(3);
dummy = camParaCalib(cam).f_eff./Xc(:,3);
Xu = Xc(:,1).*dummy;  % undistorted image coordinates
Yu = Xc(:,2).*dummy;
ru2 = Xu.*Xu + Yu.*Yu;
dummy = 1+camParaCalib(cam).k1*ru2;
Xd = Xu./dummy;
Yd = Yu./dummy;

%% iterate once
% dummy = 1 + camParaCalib(cam).k1*(Xd.*Xd + Yd.*Yd);
% Xd = Xu.*dummy;
% Yd = Yu.*dummy;

%%kstar is  the 
Np = size(Xtest3D,1);
Xtest_proj = zeros(Np,2);
Xtest_proj(:,1) = Xd/camParaCalib(cam).wpix + camParaCalib(cam).Noffw + camParaCalib(cam).Npixw/2;
Xtest_proj(:,2) = camParaCalib(cam).Npixh/2 - camParaCalib(cam).Noffh - Yd/camParaCalib(cam).hpix;

