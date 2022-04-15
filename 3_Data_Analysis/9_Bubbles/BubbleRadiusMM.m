function r_mm = BubbleRadiusMM(radius, camParaCalib)
n_cam = size(camParaCalib, 1);
co = [0, 0, 0]';
pixel_size = 0.02;
% f = 180;
% Da = f / 32;

% %%
% for i = 1 : n_cam
%     % lens equation: https://flexbooks.ck12.org/cbook/cbse-physics-class-10/section/1.10/primary/lesson/lens-formula-and-magnification/
%     
%     cam_pos(i,:) = (camParaCalib(i).R \ (co - camParaCalib(i).T))';
%     do(i) = norm(cam_pos(i, :)); % distance of the focus plane to the lens
% %     di(i) = camParaCalib(i).T(3); % distance of the image plane to the lens
%     di(i) = 1 / (1 / f + 1 / do(i) );
%     M(i) = di(i) / do(i);
% end
%%
for i = 1 : n_cam
    cam_pos(i,:) = (camParaCalib(i).R \ (co - camParaCalib(i).T))';
    cam_dist(i) = norm(cam_pos(i,:));
    y = - cam_pos(i,1) / cam_pos(i, 2);
    p1 = [ 1, y, 0] * .1;
    p0 = [0, 0, 0];
    p1_2D = calibProj_Tsai(camParaCalib(i), p1);
    p0_2D = calibProj_Tsai(camParaCalib(i), p0);
    dist_2D = norm(p1_2D - p0_2D) * 0.02;
    dist_3D = norm(p1 - p0);
    M(i) = dist_2D / dist_3D;
end

r_mm = radius(:, 1:2);
for i = 1 : size(radius, 1)
    r = 0;
    for j = 1 : n_cam
        r = r + radius(i, j + 1) * pixel_size / M(j);
    end
    r_mm(i, 2) = r / n_cam;
end

% n_bubble = size(radius, 1);
% tracks = sortrows(tracks, 4);
% [C,ia,~] = unique(tracks(:,5));
% for i = 1 : n_bubble
%     id_bubble = radius(i, 1);
%     ind = C == id_bubble;
%     pos = tracks(ia(ind), 1 : 3);
%     for j = 1 :  n_cam
%         z = abs(dot(pos, -cam_pos(j,:)') / cam_dist(j));
%         d_defocus = M(j) * z * Da / (cam_dist(j) + z);
% %         d_p(j) = ((4 * (radius(i, 2) * pixel_size) ^ 2 - d_defocus ^ 2) / M(j) ^ 2) ^ .5;
%         d_p(j) = ((4 * (radius(i, 2) * pixel_size) ^ 2) / M(j) ^ 2) ^ .5;
%     end
%     r_mm(i) = mean(d_p) / 2;
% end

end
%%
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
