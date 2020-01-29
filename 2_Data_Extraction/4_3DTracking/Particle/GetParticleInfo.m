function particles_info = GetParticleInfo(particles, image_path, calib_path)
num_particles = size(particles, 1);
load(calib_path);
particles_info = zeros(num_particles, 15);

ii = 1; % index for particles_info
for i = 1 : num_particles
% Project the particle on each image
   xc = zeros(1, 4); yc = zeros(1, 4);
   for j = 1 : 4
       X2D = calibProj(camParaCalib(j), particles(i, 1:3));
       xc(j) = X2D(1); yc(j) = X2D(2);
   end
   
   delete_particle  = 0;
% Get the 2D positions around the projected point
    for j = 1 : 4
        img = imread([image_path 'cam' num2str(j) '/cam' num2str(j) 'frame' num2str(particles(i, 4), '%04.0f') '.tif']);
        particle_size = 4;
        search_range = particle_size * 3 / 4; % searching range on the image
        img_searcharea = img(max(1, floor(yc(j) - search_range)) : min(1024, ceil(yc(j) + search_range)), ...
            max(1, floor(xc(j) - search_range)) : min(1024, ceil(xc(j) + search_range))); % get the search area
        position2D_candidate = Get2DPosOnImage(img_searcharea);
        if ~isempty(position2D_candidate)
            position2D_candidate(:, 1) = position2D_candidate(:,1) + max(1, floor(xc(j) - search_range)) - 1;
            position2D_candidate(:, 2) = position2D_candidate(:,2) + max(1, floor(yc(j) - search_range))- 1;
            switch j
                case 1
                    position2D_candidate_1 = position2D_candidate;
                case 2
                    position2D_candidate_2 = position2D_candidate;
                case 3
                    position2D_candidate_3 = position2D_candidate;
                case 4
                    position2D_candidate_4 = position2D_candidate;
            end
        else
            delete_particle  = 1;
            break;
        end
    end
    
    if delete_particle % delete the particle 
        particles_info(ii, :) = [];
        continue;
    end

% Do triangulation for each combination of 2D positions
    len1 = size(position2D_candidate_1, 1); len2 = size(position2D_candidate_2, 1);
    len3 = size(position2D_candidate_3, 1); len4 = size(position2D_candidate_4, 1);
    particle = zeros(len1 * len2 * len3 * len4, 15);
    error = zeros(1, len1 * len2 * len3 * len4);
    for j = 1 : len1
        for k = 1 : len2
            for m = 1 : len3
                for n = 1 : len4
                    position2D = [position2D_candidate_1(j, :), position2D_candidate_2(k, :), ...
                        position2D_candidate_3(m, :), position2D_candidate_4(n, :)];
                    [position3D, e] = Triangulation(camParaCalib, position2D);
                    error((j - 1) * len2 * len3 * len4 + (k - 1) * len3 * len4 + (m -1) * len4 + n) = e;
                    particle((j - 1) * len2 * len3 * len4 + (k - 1) * len3 * len4 + (m -1) * len4 + n, :) = ...
                        [position3D', position2D, norm(position3D' - particles(i, 1:3)), particles(i, 1:3)];
                    % the last one is the distance from the projected particle
                end
            end
        end
    end
    
% Choose the closest one to the projected particle as the real particle
    thred_3D = .05; 
    ind = find(error < thred_3D);
    if isempty(ind)
        particles_info(ii, :) = []; % delete the particle since there is no suitable candidate
        continue;
    end
    
    particle = particle(ind, :);
    error = error(ind);
     [~, index] = min(particle(:, 12) / mean(particle(:, 12)) ...
         + error' / mean(error)); % combination of goal achieving the minimum distance as well as minimum error
%     [~, index] = min(error);
    particles_info(ii, :) = particle(index, :);
    ii = ii + 1;
    if ~(mod(i, 100)) 
        ['Processing the ' num2str(i) 'th particle...']
    end
end

end