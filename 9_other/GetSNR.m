function result = GetSNR(particles, DoF, camParaCalib)

signal_focus = 0;
signal_blur = 0;
% signal_value = 0;
noise = 0;
% noise_value = 0;
D = 0;
D_e = 0;
data2 = [];
    for dx = [-40 0 40]
        for dy = [-40 0 40]
%             if dx == 0 && dy == 0
%                 continue;
%             end
            if dx == 0 && dy == 0
                data3 = particles(:, 1:3);
            else
                data3 = particles(:, 1:3); %* reshape(rotate_array(rotate_index, :, :), 3, 3); % rotate it randomly
                
            end
            data3(:,1) = data3(:, 1) + dx;
            data3(:,2) = data3(:, 2) + dy;
            data2 = [data2; data3];
        end
    end
%     particles = data2;  
    clear data2;
    num_part = size(particles, 1);
    h = waitbar(0);
for i = 1 : num_part
    [J, d_i] = GenerateBlurParticle(particles(i, 1:3) , camParaCalib, DoF);
    waitbar(i/num_part, h, [num2str(i/num_part*100) '%...']);
    if J > 30
        if abs(particles(i, 1)) > 20 ||  abs(particles(i, 2)) > 20 || abs(particles(i, 3)) > 20
            noise = noise + 1;
            %noise_value = noise_value + double(J);
        else
            if d_i <= 4
                signal_focus = signal_focus + 1;
            else
                signal_blur = signal_blur + 1;
            end
            %signal_value = signal_value + double(J);
            D_e = D_e +d_i;
        end
        D = D + d_i;
    end
end
% noise_value = noise_value / noise;
% signal_value = signal_value / signal;
d = D / (noise + signal_focus + signal_blur);
d_e = D_e / (signal_focus + signal_blur);
result = [ signal_focus, signal_blur, noise, d, d_e];
end

function [J, d_i] = GenerateBlurParticle( pos, camParaCalib, DOF)
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
% DOF = 10; % depth of field 13.5
d_max = 5; % acceptable maximum value of particle projection
            % when the projection is larger than 5, than the intensity is
            % low to be identified
            % Use this value to determin CoC
CoC = (d_max - ceil(d_real * M * 1024 / 20)) * 20 / 1024; % circle of confusion 


% pos = [-29, 0, 0];
%      cam_pos(1,:) = [400 0 0];
J = 0;
for cam = 1 : 1
    f = camParaCalib(cam).f_eff; % focal length 
    cam_dist = norm(cam_pos(cam,:));
    size_apertrure = 2 * cam_dist ^ 2 * CoC / (DOF * f);
%     size_apertrure = f / 22;
    del_pos = dot(pos, -cam_pos(cam,:)') / cam_dist;
%     if del_pos > 0
%         del_pos = del_pos - focus_dist;
%     else 
%         del_pos = del_pos + focus_dist;
%     end
    part_dist = cam_dist + del_pos;
    % part_dist = cam_dist + del_pos;
    % del_pos_adj = norm(pos) - norm([25, 25, 25]);
    % height_part = norm(cross(cam_pos(1, :), pos)) / norm(cam_pos(1, :));
    d_defocus =  M * del_pos * size_apertrure / part_dist;

    d_part_img = ((M * d_real) ^ 2 + d_defocus ^ 2) ^ .5;

    a = 255; b = .9;
    A = a * d_image ^ 2 * cam_dist ^ 2;
    B = b * d_image ^ 2;

    center2D = round(calibProj_Tsai(camParaCalib(cam), pos));
    project_size = 5;
    ysize = 1024; xsize = 1024;
    if center2D(1) <= project_size || center2D(1) >= xsize - project_size ||...
       center2D(2) <= project_size || center2D(2) >= ysize - project_size
        d_i = Inf;
        continue; % out of camera range
    end
   
%     if A / d_part_img ^ 2 / part_dist ^ 2 > 40 
%         J = 1;
%     end
    J = uint8(A / d_part_img ^ 2 / part_dist ^ 2) ;
    
%     syms i;
%     eq = A / d_part_img ^ 2 / part_dist ^ 2 * exp(-B * i^ 2 / d_part_img ^ 2) == 10;
%     r_i = solve(eq, i);
    r_i = (log(10 / A * d_part_img ^ 2 * part_dist ^ 2) / (-B) * d_part_img ^ 2) ^ .5;
%     d_i = round(vpa(r_i(2)) * 2);
    d_i = round(r_i * 2);
%     for i = center2D(1) - project_size : center2D(1) + project_size
%         for j = center2D(2) - project_size : center2D(2) + project_size
%             J(cam, j, i) = max(J(cam, j, i),  uint8(A / d_part_img ^ 2 / part_dist ^ 2 * exp(-B * ((i - center2D(1))^ 2 + (j - center2D(2)) ^ 2) / d_part_img ^ 2)));
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