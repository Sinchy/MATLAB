function PlayBubbleVideo(imgdir, track1, track2, radius1, radius2, cam, camParaCalib)

min_frame = min([track1(:,4); track2(:,4)]);
max_frame = max([track1(:,4); track2(:,4)]);
pos2d1 = calibProj_Tsai(camParaCalib(cam), track1(:,1:3));
pos2d2 = calibProj_Tsai(camParaCalib(cam), track2(:,1:3));

for i = min_frame : max_frame
    img = imread([imgdir 'cam_' num2str(cam) '/cam' num2str(cam) 'frame' num2str(i,'%06.0f') '.tif']);
    imshow(img)
    hold on
    ind1 = track1(:,4) == i; ind2 = track2(:,4) == i;
    if sum(ind1) > 0
        viscircles(pos2d1(ind1, :), radius1, 'LineWidth', 0.5);
    end
     if sum(ind2) > 0
        viscircles(pos2d2(ind2, :), radius2, 'LineWidth', 0.5);
     end
    pause(0.1)
end
end

function Xtest_proj = calibProj_Tsai(camParaCalib, Xtest3D)
% Use the calibrated camera parameters to predict the particle position
% projected onto the image plane.
%
% inputs:
%   camParaCalib    --  calibrated camera parameters
%   Xtest3D         --  test particle coordinates in 3D world system
%
% output:
%   Xtest_proj      --  projected particle position on image plane (in
%   pixels)
%% Note that this is the second version: remove the iteration on k1, add kstar


%%

Xc = Xtest3D * (camParaCalib.R)';
Xc(:,1) = Xc(:,1) + camParaCalib.T(1);
Xc(:,2) = Xc(:,2) + camParaCalib.T(2);
Xc(:,3) = Xc(:,3) + camParaCalib.T(3);
dummy = camParaCalib.f_eff./Xc(:,3);
Xu = Xc(:,1).*dummy;  % undistorted image coordinates
Yu = Xc(:,2).*dummy;
ru2 = Xu.*Xu + Yu.*Yu;
dummy = 1+camParaCalib.k1*ru2;
Xd = Xu./dummy;
Yd = Yu./dummy;

%% iterate once
% dummy = 1 + camParaCalib.k1*(Xd.*Xd + Yd.*Yd);
% Xd = Xu.*dummy;
% Yd = Yu.*dummy;

%%kstar is  the 
Np = size(Xtest3D,1);
Xtest_proj = zeros(Np,2);
Xtest_proj(:,1) = Xd/camParaCalib.wpix + camParaCalib.Noffw + camParaCalib.Npixw/2;
Xtest_proj(:,2) = camParaCalib.Npixh/2 - camParaCalib.Noffh - Yd/camParaCalib.hpix;
end
