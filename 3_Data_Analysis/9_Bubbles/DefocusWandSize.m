%% get the position for wand point 1
addpath D:\0.Code\MATLAB\2_Data_Extraction\4_3DTracking\Particle
wandpts_m = cell2mat(wandpts');
radius_m = cell2mat(radius');
for i = 1 : size(wandpts_m, 1)
pos(i, :) = Triangulation(camParaCalib, wandpts_m(i, 1:6));
end
%% cam1 and wand point 1
cam_pos= (camParaCalib(1).R \ ([0 0 0]' - camParaCalib(1).T))'; % camera position
cam_dist = norm(cam_pos); 
for i = 1 : size(wandpts_m, 1)
    dist(i) = dot(pos(i, :), cam_pos')/cam_dist;
end
figure
plot(dist, radius_m(:,2), 'b.')

%% cam2 and wand point 1
cam_pos= (camParaCalib(2).R \ ([0 0 0]' - camParaCalib(2).T))'; % camera position
cam_dist = norm(cam_pos); 
for i = 1 : size(wandpts_m, 1)
dist(i) = dot(pos(i, :), cam_pos')/cam_dist;
end
figure
plot(dist, radius_m(:,3), 'b.')

%% cam3 and wand point 1
cam_pos= (camParaCalib(3).R \ ([0 0 0]' - camParaCalib(3).T))'; % camera position
cam_dist = norm(cam_pos); 
for i = 1 : size(wandpts_m, 1)
dist(i) = dot(pos(i, :), cam_pos')/cam_dist;
end
figure
plot(dist, radius_m(:,5), 'b.')

%% camera magnification
n_cam = size(camParaCalib, 1);
co = [0 0 0]';
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

%% wand point1 size
r_p1 = 1.5;%mm
f = 180;
Da = f / 32;
pixel_size =0.02;
% for camera 1
for i = 1 : size(pos, 1)
    d_defocus(i) = (2 * pixel_size * radius_m(i, 1)) ^ 2 - (M(1) * r_p1 * 2) ^ 2; 
end
figure
plot(dist, d_defocus, 'b.')



%% get bubble track image
track1 = tracks(tracks(:, 5) == 12, :);
addpath D:\0.Code\MATLAB\2_Data_Extraction\4_3DTracking\Micro_bubble_tracking
[img_bubble, img_overlap] = GetImageOnTracks('C:\Users\ShiyongTan\Documents\Data_processing\20220204\T3\S1\', track1, 14,camParaCalib, 1);

%% Plot the track image
figure
imshow(reshape(img_overlap(1, :, :), [800, 1280]))

%% get the radius of bubble in each frame
[num_frame, ~, row, col] = size(img_bubble);
for i = 1 : num_frame
    i_b = reshape(img_bubble(i, 3, :, :), [row, col]);
    [~, r] = imfindcircles(i_b, [10 15], 'Sensitivity', .95);
    if isempty(r)
        r_b(i) = 0;
        continue;
    end
    if length(r) > 1
        r_b(i) = 0;
        continue;
    end
    r_b(i) = r;
end
%% bubble size along the axis of a camera
cam_pos= (camParaCalib(1).R \ ([0 0 0]' - camParaCalib(1).T))'; % camera position
cam_dist = norm(cam_pos); 
for i = 1 : size(num_frame, 1)
    dist(i) = dot(track1(i, 1:3), cam_pos')/cam_dist;
end
ind = r_b > 0;
figure
plot(dist(ind), r_b(ind), 'b.');
r_b1 = mean(nonzeros(r_b));

%% defocus effect
M = 0.5;
Da = 180/32;
d = 1000;
z = 0:.1:60;
df = M * Da * z ./(z+d);
figure
plot(z, df);

%% fit parameter for the defocus model
for i = 1 : size(pos, 1)
    dist_fromcam(i) = dot(cam_pos(1, :) - pos(i, :), cam_pos(1,:)') / cam_dist(1) ;
end
d_image = 2 * radius_m(:,1) * pixel_size;
d_image_square = d_image .^2;
f = fittype('(M * 3) ^ 2 + (M * 5.6 * (x - d)/x) ^2');
model = fit(dist_fromcam, d_image_square, f, 'StartPoint', [M(1), cam_dist(1)]);

%% fit parameter for the defocus model 2
for i = 1 : size(pos, 1)
    dist_fromcam(i) = dot(cam_pos(1, :) - pos(i, :), cam_pos(1,:)') / cam_dist(1) ;
end
d_image = 2 * radius_m(:,2) * pixel_size;
d_image_square = d_image .^2;
d_defocus_square = d_image_square - (M(1) * 2 * 2) ^2;
% figure
plot(dist_fromcam, d_defocus_square, 'b.');

%% fit parameter for the camera model
pixel_size =0.02;
cam_direction = -camParaCalib(1).Tinv;
do = norm(cam_direction);
param0 = [cam_direction'/do, do];
r_p = 1.5;
fmin_options.Display = 'iter'; %'final' to display only the final mean distance, 'iter' to show the steps along the way.
fmin_options.MaxIter = 10000; %350;
% fmin_options.TolX = 1e-8;
fmin_options.TolFun = 1e-10;
[x,fval,exitflag,output] = fminsearch( @CamParaMin, param0, fmin_options, camParaCalib(1), pos, r_p, radius_m(:,1) * pixel_size);
x(1:3) = x(1:3) / norm(x(1:3));
%% Validation by using wand point 2

for i = 1 : size(wandpts_m, 1)
pos2(i, :) = Triangulation(camParaCalib, wandpts_m(i, 7:12));
end


%%
r_p2 = 2;
fmin_options.TolFun = 1e-10;
[x,fval,exitflag,output] = fminsearch( @CamParaMin, param0, fmin_options, camParaCalib(1), pos, r_p2, radius_m(:,2) * pixel_size);
%%
r_i1 = CameraModel(pos, r_p, camParaCalib(1), x(1), x(2), x(3), x(4));
dr1 = r_i1 - radius_m(:,1)' * pixel_size;
 r_i2 = CameraModel(pos2, r_p2, camParaCalib(1), x(1), x(2), x(3), x(4));
 dr2 = r_i2 - radius_m(:,2)' * pixel_size;

%% minmum function
function fmin = CamParaMin(param, camParaCalib, pos, r_p, r_image)
    x_ca = param(1);
    y_ca = param(2);
    z_ca = param(3);
    do = param(4);
    r_i = CameraModel(pos, r_p, camParaCalib, x_ca, y_ca, z_ca, do);
    fmin = mean((r_i - r_image').^2) ^ .5;
end

