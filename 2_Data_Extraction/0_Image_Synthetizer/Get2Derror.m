function [error, error_aver, error_std, reject]= Get2Derror(tracks, image_path, calib_path)
% get the 2D postions on the image
num_part = size(tracks, 1);
if num_part > 100000
    tracks = tracks(1 : round(num_part / 100000) : end, :);
end
particles_info = GetParticleInfo(tracks, image_path, calib_path);
num_part = size(particles_info, 1);
error = zeros(num_part, 8);
error_polar = zeros(num_part, 8);
load(calib_path);
for i = 1 : num_part
    center = zeros(1, 8);
    for j = 1 : 4
       X2D = calibProj(camParaCalib(j), particles_info(i, 13 : 15));
       center((j-1) * 2 + 1 : (j-1) * 2 + 2) = X2D;
    end
    error(i, :) = particles_info(i, 4 : 11) - center;
    for j = 1 : 4
        error_polar(i, (j-1) * 2 + 1) = norm(error(i, (j-1) * 2 + 1 : (j-1) * 2 + 2));
        error_polar(i, (j-1) * 2 + 2) = atan2(error(i, (j-1) * 2 + 2), error(i, (j-1) * 2 + 1));
    end
end
error = [particles_info(:, 13 : 15) particles_info(:, 4 : 11) error error_polar];
% average for each grid
xl = min(particles_info(:,1)); xu = max(particles_info(:,1));
yl = min(particles_info(:,2)); yu = max(particles_info(:,2));
zl = min(particles_info(:,3)); zu = max(particles_info(:,3));

n_div = 10;
for i = 1 : n_div
    for j = 1 : n_div
        for k = 1 : n_div
            xl_grid = xl + (i - 1) * (xu - xl) / n_div; xu_grid = xl + i * (xu - xl) / n_div; 
            yl_grid = yl + (j - 1) * (yu - yl) / n_div; yu_grid = yl + j * (yu - yl) / n_div;
            zl_grid = zl + (k - 1) * (zu - zl) / n_div; zu_grid = zl + k * (zu - zl) / n_div;
            sample = error(error(:,1) > xl_grid & error(:,1) < xu_grid & ...
                error(:,2) > yl_grid & error(:,2) < yu_grid & ...
                error(:,3) > zl_grid & error(:,3) < zu_grid , 20 : 27);
            sample_pack{(i - 1) * 100 + (j - 1) * 10 + k} = sample;
            error_aver(i,j,k, :) = mean(sample);
            error_std(i,j,k, :) = std(sample);
        end
    end
end

%t-test
reject = 0;
for i = 1 : n_div ^ 3
    if isempty(sample_pack{i}) 
        continue;
    end
    sample1 = sample_pack{i};
    if size(sample1,1) < 20 continue; end
    for j = i + 1 : n_div^3
        if isempty(sample_pack{j}) 
            continue;
        end
        sample2 = sample_pack{j};
        if size(sample2,1) < 20 continue; end
        h1 = ttest2(sample1(:,1), sample2(:,1));
        h2 = ttest2(sample1(:,2), sample2(:,2));
        if h1 + h2 > 1
            reject = reject + 1;
        end
    end
end

end

function particles_info = GetParticleInfo(particles, image_path, calib_path)
num_particles = size(particles, 1);
load(calib_path);
particles_info = zeros(num_particles, 16);

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
        img = imread([image_path 'cam' num2str(j) '/cam' num2str(j) 'frame' num2str(particles(i, 4), '%05.0f') '.tif']);
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
    particle = zeros(len1 * len2 * len3 * len4, 16);
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
                        [position3D', position2D, norm(position3D' - particles(i, 1:3)), particles(i, 1:4)];
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

function position2D = Get2DPosOnImage(img) 
[rows, cols] = size(img);
threshold = 35;
position2D = [];
for i = 2 : rows - 1
    for j = 2 : cols - 1
        if (img(i, j) >= threshold && IsLocalMax(img, i, j))
            x1 = j - 1; x2 = j; x3 = j + 1;
            y1 = i - 1; y2 = i; y3 = i + 1;
            ln1 = NoInfLog(img(i, j - 1));
            ln2 = NoInfLog(img(i, j));
            ln3 = NoInfLog(img(i, j + 1));
        
            xc = -.5 * (ln1 * (x2 ^ 2 - x3 ^ 2) - ln2 * (x1 ^ 2 - x3 ^ 2) + ln3 * (x1 ^ 2 - x2 ^ 2)) / ...
            (ln1 * (x3 - x2) - ln3 * (x1 - x2) + ln2 * (x1 - x3));
            
            ln1 = NoInfLog(img(i - 1, j));
            ln2 = NoInfLog(img(i, j));
            ln3 = NoInfLog(img(i + 1, j));
            yc = -.5 * (ln1 * (y2 ^ 2 - y3 ^ 2) - ln2 * (y1 ^ 2 - y3 ^ 2) + ln3 * (y1 ^ 2 - y2 ^ 2)) / ...
            (ln1 * (y3 - y2) - ln3 * (y1 - y2) + ln2 * (y1 - y3));
            
            if (~isinf(xc) && ~isinf(yc))
                position2D = [position2D; xc, yc];
            end
        end
    end
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

function result = IsLocalMax(img, i, j)
   result = 1;
   if (img(i - 1, j) > img(i, j) || img(i + 1, j) > img(i, j) || ...
           img(i, j - 1) > img(i, j) || img(i, j + 1) > img(i, j))
       result = 0;
   end
end

function y = NoInfLog(x)
if x == 0
    x = .0001;
end
y = log(double(x));
end

function [position3D, error] = Triangulation(camParaCalib, position2D) 
A = zeros(3, 3);
B = zeros(3, 1);
D = 0;
for i = 1 : 4
    % get the world position of the point on the image
    SIpos = Img2World(camParaCalib(i), UnDistort(position2D((i - 1) * 2 + 1 : (i - 1) * 2 + 2), camParaCalib(i))); 
    % get the vector 
    sight = SIpos - camParaCalib(i).Tinv;
    sight = sight / norm(sight); 
    C = eye(3) - sight *  sight';
    A = A + C;
    B = B + C * camParaCalib(i).Tinv;
    D = D + camParaCalib(i).Tinv' * C * camParaCalib(i).Tinv;
end
position3D = A \ B;
error = (position3D' * A * position3D - 2 * position3D' * B + D) ^ .5 / 4;
end

function x2D = UnDistort(X2D,camParaCalib) 
    
    kr = camParaCalib.k1;
    X = (X2D(:,1) - 512)*0.02;
    Y = (-X2D(:,2) + 512)*0.02;

    if (kr ~= 0)
        a = X ./ Y;

        Y = (1 - sqrt(1 - 4 .* Y.^2 .* kr.*(a.^2 + 1))) / (2.* Y.* kr.* (a.^2 + 1));
        X = a.*Y;
    end
    
    x2D = [X Y];
end

function X3D = Img2World(camParaCalib,X2D)

    s = [size(X2D,1);size(X2D,2)];
%     X2D = [X2D zeros(s(1),1)];
    tmp = X2D.*(camParaCalib.T(3)/camParaCalib.f_eff);
    proj = [tmp(:,1) tmp(:,2) repmat(camParaCalib.T(3),[s(1) 1])]';
    X3D = camParaCalib.Rinv*(proj - camParaCalib.T);

end