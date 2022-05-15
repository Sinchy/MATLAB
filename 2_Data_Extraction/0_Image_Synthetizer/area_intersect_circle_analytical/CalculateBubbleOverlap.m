function overlap = CalculateBubbleOverlap(tracks, r_mm, camParaCalib)
addpath D:\0.Code\MATLAB\2_Data_Extraction\0_Image_Synthetizer
frame_no = unique(tracks(:,4));
n_frame = length(frame_no);
overlap = cell(n_frame, 1);
ncam = size(camParaCalib, 1);
radius = BubbleRadiusMM(r_mm, camParaCalib);
for i = 1 : n_frame
    frame = tracks(tracks(:, 4) == frame_no(i), :);
    n_particle = size(frame, 1);
    pos2D = zeros(n_particle, ncam * 2);
    r = zeros(n_particle, 1);
    for j = 1 : n_particle
        r(j) = radius(radius(:,1) == frame(j, 5), 2);
    end
    for j = 1 : ncam
        pos2D(:, (j - 1) * 2 + 1: j * 2 ) = calibProj_Tsai(camParaCalib(j), frame(:, 1:3));
    end
    frame_overlap = zeros(n_particle, ncam);
    for j = 1 : ncam
        ind = pos2D(:, (j - 1) * 2 + 1) < 1 | pos2D(:, (j - 1) * 2 + 1)  > camParaCalib(j).Npixw ...
            | pos2D(:, j * 2) < 1 | pos2D(:, j * 2)  > camParaCalib(j).Npixh;
        frame_overlap(ind, j) = -1; % out of image
        pos2D_img = pos2D(~ind, (j - 1) * 2 + 1: j * 2);
        r_img = r(~ind);
        G = [pos2D_img r_img];
        M = area_intersect_circle_analytical(G);
        frame_overlap(~ind, j) = (sum(M, 2) - diag(M)) ./ diag(M);
    end
    overlap{i} = [frame_overlap frame(:, 5)];
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
