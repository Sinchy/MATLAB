function shake_point = PositionRefine(est_point, radii, image_dir, frame_num, camParaCalib)
    image_path = strings(1,4);
    for i = 1 : 4
%         image_path(i) = fullfile([image_dir 'cam' num2str(i) '/cam' num2str(i) 'frame' num2str(frame_num + 1,'%04.0f') '.tif']);
        image_path(i) = fullfile([image_dir 'cam_' num2str(i) '/cam' num2str(i) 'frame' num2str(frame_num,'%06.0f') '.tif']);
    end

    [point_num, ~] = size(est_point); 
    loop_num = 4;
%     project_size = 4; % project size depends on the size of the particles
    project_size = radii * 2;
    intensity = ones(1, point_num);
    shake_point = est_point;
     shift = .12 * 2; 
    for i = 1 : loop_num
        shift = shift / 2;
        [shake_point, intensity] = Shake(shake_point, camParaCalib, intensity, image_path, shift, project_size);   
    end
end


function [shake_point, intensity] = Shake(est_point, camParaCalib, intensity,  image_path, shift, project_size) 
%% get the residual image
    % get the origin image
    npixh = camParaCalib(1).Npixh;
    npixw = camParaCalib(1).Npixw;
    origin_img = zeros(4, npixh, npixw);
    for i = 1 : 4
        origin_img(i, :, :) = uint8(imread(convertStringsToChars(image_path(i))));
    end
    % get the reprojected image
    [project_img, xc, yc] = ProjectImage(est_point, camParaCalib, project_size * 2); % double size of reprojecting area
    % get the residual image
    residual_img = origin_img - project_img;
    
    [num_point, ~] = size(est_point);
    shake_point = zeros(num_point, 3);
    for i = 1 : num_point
        % get the augmented image
        augment_img = GetAugmentResImage(residual_img,  est_point(i, :), camParaCalib, project_size(i) * 2, xc(i, :), yc(i, :)); % using the origin particle as the projected center
        shake_point(i, :) = Shaking(augment_img, est_point(i,:), camParaCalib, shift, project_size(i) * 2, xc(i, :), yc(i, :));
        intensity(i) = CalculateIntensity(intensity(i), augment_img, shake_point(i, :), camParaCalib, project_size(i)); % calculating the intensity in one project size
    end
end

function augment_img = GetAugmentResImage(residual_img,  est_point, camParaCalib,  project_size, xc, yc) 
     npixh = camParaCalib(1).Npixh;
    npixw = camParaCalib(1).Npixw;
    augment_img = residual_img;
    for i = 1 : 4
        for x = max(1, floor(xc(i) - project_size / 2)) : min(npixw, floor(xc(i) + project_size / 2)) - 1
            for y = max(1, floor(yc(i) - project_size / 2)) : min(npixh, floor(yc(i) + project_size / 2)) - 1
                [part_proj, ~, ~] = GaussianProjection(est_point, camParaCalib, project_size, i, x, y);
                augment_img(i, y, x) = max(0, min(255, residual_img(i, y, x) + part_proj));
            end
        end
    end
end

function shake_point = Shaking(augment_img, est_point, camParaCalib, shift, project_size, xc, yc)
    shake_point = zeros(1, 3);
    % shaking in three axies
    for i = 1 : 3
        % shift in one axis 
        new_est_point = [est_point; est_point; est_point];
        new_est_point(1, i) = new_est_point(1, i) - shift;
        new_est_point(3, i) = new_est_point(3, i) + shift;
        residual = zeros(1,3);
        for j = 1 : 3
            residual(j) = CalculateRedidual(augment_img, new_est_point(j, :), camParaCalib,  project_size, xc, yc);
        end
        % quadratic fit for the residual
        fit = polyfit(new_est_point(:, i)', residual, 2);
        quadractic_function = @(x) fit(1) * x ^ 2 + fit(2) * x + fit(3);
        % get the position with the minimum residual
        shake_point(i)= fminbnd(quadractic_function, new_est_point(1, i), new_est_point(3, i));
        est_point(i) = shake_point(i);
    end
    
end

function intensity = CalculateIntensity(intensity, augment_img, shake_point, camParaCalib, project_size)
    % find the camera which has the highest intensity
    npixh = camParaCalib(1).Npixh;
    npixw = camParaCalib(1).Npixw;
    [project_img, xc, yc] = GaussianProjection(shake_point, camParaCalib, project_size);
    [~, index] = max(project_img(:));
    [cam_index, ~, ~] = ind2sub(size(project_img), index);
    num = 0; denum = 0;
    for i = 1:4
        if i ~= cam_index
           for x = max(1, floor(xc(i) - project_size / 2)) : min(npixw, floor(xc(i) + project_size / 2)) - 1
                for y = max(1, floor(yc(i) - project_size / 2)) : min(npixh, floor(yc(i) + project_size / 2)) - 1
                   num = num + augment_img(i, y, x);
                   denum = denum + project_img(i, y, x);
                end
           end
        end
    end
    intensity = intensity * (abs(num /  denum)) ^ .5;
end

function residual = CalculateRedidual(augment_img, est_point, camParaCalib,  project_size, xc, yc)
    npixh = camParaCalib(1).Npixh;
    npixw = camParaCalib(1).Npixw;
    residual = 0;
    for i = 1:4
       for x = max(1, floor(xc(i) - project_size / 2)) : min(npixh, floor(xc(i) + project_size / 2)) - 1 
            for y = max(1, floor(yc(i) - project_size / 2)) : min(npixw, floor(yc(i) + project_size / 2)) - 1
                [part_proj, ~, ~] = GaussianProjection(est_point, camParaCalib, project_size, i, x, y);
                residual = residual + (augment_img(i, y, x) - part_proj)^ 2;
            end
       end
    end
end


function [project_img, xc, yc] = ProjectImage(est_point, camParaCalib, project_size)
    [point_num, ~] = size(est_point);
    npixh = camParaCalib(1).Npixh;
    npixw = camParaCalib(1).Npixw;
    project_img = zeros(4, npixh, npixw);
    xc = zeros(point_num, 4); yc = zeros(point_num, 4);
    for i = 1 : point_num 
        [part_proj, xc(i, :), yc(i, :)] = GaussianProjection(est_point(i, :), camParaCalib, project_size(i));
        for j = 1 : 4
            for x = max(1, floor(xc(i, j) - project_size(i) / 2)) : min(npixw, floor(xc(i, j) + project_size(i) / 2)) - 1
                for y = max(1, floor(yc(i, j) - project_size(i) / 2)) : min(npixh, floor(yc(i, j) + project_size(i) / 2)) - 1
                    project_img(j, y, x) = max(project_img(j, y, x), part_proj(j, y, x));
                end
            end
        end
    end
end

function [project_img, xc, yc] = GaussianProjection(est_point, camParaCalib, project_size, camid, pixel_x, pixel_y)
%    calib_filepath = 'D:\1.Projects\2.Bubble-Particle\Data_analysis\Image_processing\022421\Run1/VSC_Calib_022421_6.mat';
%    load(calib_filepath);
    npixh = camParaCalib(1).Npixh;
    npixw = camParaCalib(1).Npixw;
   xc = zeros(1,4);
   yc = zeros(1,4);
    
   for j = 1:4
       X2D = calibProj(camParaCalib(j), est_point);
       xc(j) = X2D(1); yc(j) = X2D(2);
   end

   Xp = est_point(1); Yp = est_point(2); Zp = est_point(3); 
   
   if ~exist('pixel_x','var')
       project_img = zeros(4, npixh, npixw);
   end
       
   if ~exist('./OTFParameters.mat', 'file')
       % view area
       view_size = 25;
       x3Dmin = -view_size; y3Dmin = -view_size; z3Dmin = -view_size;
       x3Dmax = view_size; y3Dmax = view_size; z3Dmax = view_size; %dimension of 3D volume in mm    
   end
   
   alpha = zeros(1,4); a = zeros(1,4); b = zeros(1,4); c = zeros(1,4); 
   if ~exist('pixel_x','var')
       for i = 1:4
           if ~exist('./OTFParameters.mat', 'file')
               [a0(:,:,:,i),b0(:,:,:,i),c0(:,:,:,i),alpha0(:,:,:,i),x0(:,:,:,i),y0(:,:,:,i),z0(:,:,:,i)] = ...
                   OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,i - 1);
               if i == 4 save('OTFParameters.mat', 'a0','b0','c0','alpha0','x0','y0','z0'); end
           else
               load('./OTFParameters.mat');
           end
            % 3D Interpolation of the OTF parameters
%            alpha(i) = interp3(x0(:,:,:,i),y0(:,:,:,i),z0(:,:,:,i),alpha0(:,:,:,i),Xp,Yp,Zp);
%            a(i) = interp3(x0(:,:,:,i),y0(:,:,:,i),z0(:,:,:,i),a0(:,:,:,i),Xp,Yp,Zp);
%            b(i) = interp3(x0(:,:,:,i),y0(:,:,:,i),z0(:,:,:,i),b0(:,:,:,i),Xp,Yp,Zp);
%            c(i) = interp3(x0(:,:,:,i),y0(:,:,:,i),z0(:,:,:,i),c0(:,:,:,i),Xp,Yp,Zp);
            a(i) = 255;
            b(i) =1 /( (project_size / 4) ^ 2);
            c(i) = b(i);
            alpha(i) = 0;

           % Gaussian projection
           for x = max(1, floor(xc(i) - project_size / 2)) : min(npixw, floor(xc(i) + project_size / 2)) - 1
               for y = max(1, floor(yc(i) - project_size / 2)) : min(npixh, floor(yc(i) + project_size / 2)) - 1
                    xx = (x - xc(i)) * cos(alpha(i)) + (y - yc(i)) * sin(alpha(i));
                    yy = -(x - xc(i)) * sin(alpha(i)) + (y - yc(i)) * cos(alpha(i));
                    project_img(i,y,x) = max(project_img(i,y,x), round(a(i) * exp(-(b(i) * (xx)^2 + c(i) * (yy)^2)))); % not sure if max is the right thing to use for overlapping particles
               end
           end 
       end
   else
       if ~exist('./OTFParameters.mat', 'file')
           [a0(:,:,:,camid),b0(:,:,:,camid),c0(:,:,:,camid),alpha0(:,:,:,camid),x0(:,:,:,camid),y0(:,:,:,camid),z0(:,:,:,camid)] = ...
               OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,camid - 1);
           if i == 4 save('OTFParameters.mat', 'a0','b0','c0','alpha0','x0','y0','z0'); end
       else
           load('./OTFParameters.mat');
       end
        % 3D Interpolation of the OTF parameters
%        alpha= interp3(x0(:,:,:,camid),y0(:,:,:,camid),z0(:,:,:,camid),alpha0(:,:,:,camid),Xp,Yp,Zp);
%        a = interp3(x0(:,:,:,camid),y0(:,:,:,camid),z0(:,:,:,camid),a0(:,:,:,camid),Xp,Yp,Zp);
%        b = interp3(x0(:,:,:,camid),y0(:,:,:,camid),z0(:,:,:,camid),b0(:,:,:,camid),Xp,Yp,Zp);
%        c = interp3(x0(:,:,:,camid),y0(:,:,:,camid),z0(:,:,:,camid),c0(:,:,:,camid),Xp,Yp,Zp);

            a = 255;
            b = 1 /( (project_size / 4) ^ 2);
            c = b;
            alpha = 0;
       xx = (pixel_x - xc(camid)) * cos(alpha) + (pixel_y - yc(camid)) * sin(alpha);
       yy = -(pixel_x - xc(camid)) * sin(alpha) + (pixel_y - yc(camid)) * cos(alpha);
       project_img = round(a * exp(-(b * (xx)^2 + c * (yy)^2)));
   end
end

function Xtest_proj = calibProj(camParaCalib, Xtest3D)
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

    Xc = Xtest3D * (camParaCalib.R)';
    Xc(:,1) = Xc(:,1) + camParaCalib.T(1);
    Xc(:,2) = Xc(:,2) + camParaCalib.T(2);
    Xc(:,3) = Xc(:,3) + camParaCalib.T(3);
    dummy = camParaCalib.f_eff ./ Xc(:,3);
    Xu = Xc(:,1) .* dummy;  % undistorted image coordinates
    Yu = Xc(:,2) .* dummy;
    ru2 = Xu .* Xu + Yu .* Yu;
    dummy = 1 + camParaCalib.k1 * ru2;
    Xd = Xu ./ dummy;
    Yd = Yu ./ dummy;
    
    Np = size(Xtest3D,1);
    Xtest_proj = zeros(Np,2);
    Xtest_proj(:,1) = Xd/camParaCalib.wpix + camParaCalib.Noffw + camParaCalib.Npixw/2;
    Xtest_proj(:,2) = camParaCalib.Npixh/2 - camParaCalib.Noffh - Yd/camParaCalib.hpix;
end

function[A,B,C,Alpha,xq,yq,zq] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,camid)
% 3D volume dimensions (mm)
% x3D x y3D x z3D

% Dividing the volume into m x m x m subvolumes
xstep = (x3Dmax-x3Dmin)/2;
ystep = (y3Dmax-y3Dmin)/2;
zstep = (z3Dmax-z3Dmin)/2;

% assigning OTF parameters for the corners, edge and face centers (origin is the center)
Xc = [x3Dmin 0 x3Dmax];
Yc = [y3Dmin 0 y3Dmax];
Zc = [z3Dmin 0 z3Dmax];
[x,y,z] = meshgrid(Xc,Yc,Zc);
a1 = 135; a2 = 255; a3 = 200; 
b1 = 1.5*1.5; b2 = 1.0*1.5; b3 = .6*1.5; 
c1 = .6*1.5; c2 = 1.0*1.5; c3 = 1.5*1.5; 
alpha1 = 0; alpha2 = 0 ; alpha3 = 0;
if (camid == 0 )
    for i = 1:3
        for j = 1:3
            a(i,j,1) = a1; b(i,j,1) = b1; c(i,j,1) = c1; alpha(i,j,1) = alpha1;
            a(i,j,2) = a2; b(i,j,2) = b2; c(i,j,2) = c2; alpha(i,j,2) = alpha2;
            a(i,j,3) = a3; b(i,j,3) = b3; c(i,j,3) = c3; alpha(i,j,3) = alpha3;
        end
    end
elseif (camid == 1)
    for i = 1:3
        for j = 1:3
            a(i,1,j) = a1; b(i,1,j) = b1; c(i,1,j) = c1; alpha(i,1,j) = alpha1;
            a(i,2,j) = a2; b(i,2,j) = b2; c(i,2,j) = c2; alpha(i,2,j) = alpha2;
            a(i,3,j) = a3; b(i,3,j) = b3; c(i,3,j) = c3; alpha(i,3,j) = alpha3;
        end
    end
elseif (camid == 2)
    for i = 1:3
        for j = 1:3
            a(1,i,j) = a1; b(1,i,j) = b1; c(1,i,j) = c1; alpha(1,i,j) = alpha1;
            a(2,i,j) = a2; b(2,i,j) = b2; c(2,i,j) = c2; alpha(2,i,j) = alpha2;
            a(3,i,j) = a3; b(3,i,j) = b3; c(3,i,j) = c3; alpha(3,i,j) = alpha3;
        end
    end
elseif (camid == 3)
    for i = 1:3
        for j = 1:3
            a(i,j,1) = a3; b(i,j,1) = b3; c(i,j,1) = c3; alpha(i,j,1) = alpha3;
            a(i,j,2) = a2; b(i,j,2) = b2; c(i,j,2) = c2; alpha(i,j,2) = alpha2;
            a(i,j,3) = a1; b(i,j,3) = b1; c(i,j,3) = c1; alpha(i,j,3) = alpha1;
        end
    end
else
    fprint('camid should be between 0 to 4');
end

    
    [xq,yq,zq] = meshgrid(x3Dmin:xstep:x3Dmax,y3Dmin:ystep:y3Dmax,z3Dmin:zstep:z3Dmax);
    
    A = interp3(x,y,z,a,xq,yq,zq);
    B = interp3(x,y,z,b,xq,yq,zq);
    C = interp3(x,y,z,c,xq,yq,zq);
    Alpha = interp3(x,y,z,alpha,xq,yq,zq);
end


