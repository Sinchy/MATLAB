function a = OTFBlurImgXaxis(camParaCalib, DOF)
    x = -18 : 0.1 : 18;
    for i = 1 : length(x)
        a(i) = GenerateBlurParticle([x(i), 0, 0], camParaCalib, DOF);
    end
end

function A_b = GenerateBlurParticle(pos, camParaCalib, DOF)
M = 2 / 4;
co = [0, 0, 0]';
for i = 1 : 4
    cam_pos(i,:) = (camParaCalib(i).R \ (co - camParaCalib(i).T))';
end

% d_real = d_image / M; % real particle size
d_real = 0.05; % size of particle: 50um
d_image = 3 * 20 / 1024; % particle size on the CCD sensor; 
                        % ideally the pixel size of a particle on image
                        % should be particle size * M
                        % however, the lens is imperfect, the size should
                        % be larger than the ideal value.
                        % 3 is picked based on the experimental image
% cam_dia = 50;
% cam_dia = 2;
%% Use DOF to get the the aperture size
% 

d_max = 5; % acceptable maximum value of particle projection
            % when the projection is larger than 5, than the intensity is
            % low to be identified
            % Use this value to determin CoC
% CoC = (d_max - ceil(d_real * M * 1024 / 20)) * 20 / 1024; % circle of confusion 
CoC = d_max * 20 / 1024;


% pos = [0, 0, 0];
 %     cam_pos(1,:) = [400 0 0];
for cam = 1 : 1
    f = camParaCalib(cam).f_eff; % focal length 
    cam_dist = norm(cam_pos(cam,:));
    size_apertrure = 2 * cam_dist ^ 2 * CoC / (DOF * f);
%      size_apertrure = f / 22;
    del_pos = dot(pos, -cam_pos(cam,:)') / cam_dist;

   % if del_pos > 0
    %    del_pos = del_pos - focus_dist;
    %else 
     %   del_pos = del_pos + focus_dist;
    %end

    part_dist = cam_dist + del_pos;
    % part_dist = cam_dist + del_pos;
    % del_pos_adj = norm(pos) - norm([25, 25, 25]);
    % height_part = norm(cross(cam_pos(1, :), pos)) / norm(cam_pos(1, :));
    d_defocus =  M * del_pos * size_apertrure / part_dist;

    d_part_img = ((M * d_real) ^ 2 + d_defocus ^ 2) ^ .5;

    a = 255; b = .9;
    A = a * d_image ^ 2 * cam_dist ^ 2;
    B = b * d_image ^ 2;

%     center2D = round(calibProj_Tsai(camParaCalib(cam), pos));
%     project_size = 5;
    
    A_b = uint8(A / d_part_img ^ 2 / part_dist ^ 2) ;
%     [~, ysize, xsize] = size(J);
%     if center2D(1) <= project_size || center2D(1) >= xsize - project_size ||...
%        center2D(2) <= project_size || center2D(2) >= ysize - project_size
%         continue; % out of camera range
%     end
   
%     for i = center2D(1) - project_size : center2D(1) + project_size
%         for j = center2D(2) - project_size : center2D(2) + project_size
%             J(cam, j, i) = max(J(cam, j, i),  uint8(A / d_part_img ^ 2 / part_dist ^ 2 * exp(cd -B * ((i - center2D(1))^ 2 + (j - center2D(2)) ^ 2) / d_part_img ^ 2)));
%         end
%     end
%     
%     for i = 1 : project_size * 2
%         for j = 1: project_size * 2
%             I(j, i) = max(J(cam, j, i),  uint8(A / d_part_img ^ 2 / part_dist ^ 2 * exp(-B * ((i - project_size)^ 2 + (j - project_size) ^ 2) / d_part_img ^ 2)));
%         end
%     end
end
end