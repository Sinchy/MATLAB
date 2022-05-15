function num_bubble = GenerateBubbleImage2(dir, camParaCalib, tracks, radius, b_ref)
total_frame = max(tracks(:,4));
num_bubble = zeros(total_frame, 1);
ncam = size(camParaCalib, 1);
npixw = camParaCalib(1).Npixw;
npixh = camParaCalib(1).Npixh;
r_pixel = BubbleRadiusMM(radius, camParaCalib);
for i = 1 :  total_frame
    img = zeros(npixh, npixw, ncam);
    particle_frame = tracks(tracks(:,4) == i, :);
    for j = 1 :  size(particle_frame, 1)
        pos = particle_frame(j, 1:3);
        r_p = r_pixel(r_pixel(:, 1) == particle_frame(j, 5), 2:ncam+1);
        n_track = 0;
        for k = 1 : ncam
            pos2D = calibProj_Tsai(camParaCalib(k), pos);
            r = round(r_p(k));
            if (pos2D(:, 1) - r < npixw && pos2D(:, 1) + r > 1 && ...
                    pos2D(:, 2) - r < npixh && pos2D(:, 2) + r > 1 )
                n_track = n_track + 1;
                b_img = imresize(b_ref, [r r]*2 + 1);
                x_min = max(1, round(pos2D(:,1) - r)); x_max = min(npixw, round(pos2D(:,1) + r));
                y_min = max(1, round(pos2D(:,2) - r)); y_max = min(npixh, round(pos2D(:,2) + r));
                for x = x_min : x_max
                    for y = y_min : y_max
                        dx =  r + round(x - pos2D(:,1)) + 1;
                        dy =  r + round(y - pos2D(:,2)) + 1;
                        if (x - pos2D(:,1))^2 + (y - pos2D(:,2))^2 <= (r + 1)^2
                            if img(y, x, k) == 0
                                img(y, x, k) = b_img(dy, dx);
                            end
                        end
                    end
                end
            end
        end
        if n_track == ncam
            num_bubble(i, 1) = num_bubble(i, 1) + 1;
        end
    end
    for cam = 1:ncam
        %         % add noise to image
        if ~exist([dir '\cam_' num2str(cam)], 'dir')
            mkdir([dir '\cam_' num2str(cam)]);
        end
        img = uint8(img);
        imwrite(img(:,:,cam),[dir '\cam_' num2str(cam) '/' 'cam' num2str(cam) 'frame' num2str(i, '%06.0f') '.tif']);
    end
end
end

function r_pixel = BubbleRadiusMM(radius, camParaCalib)
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

r_pixel = zeros(size(radius, 1), n_cam + 1);
r_pixel(:, 1) = radius(:,1);
for i = 1 : size(radius, 1)
    for j = 1 : n_cam
        r_pixel(i, j + 1) = radius(i, 2) / pixel_size * M(j);
    end
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


