function [matches_pos3D, mean_radii, std_radii, tri_err, matches_pos2D] = StereoMatching(pos2D, radii, camParaCalib, img)
ncam = size(camParaCalib, 1);
mindist_2D = .05;

% cam = cell(ncam, 1);
for i = 1 : ncam
    cam(i) = Camera(camParaCalib(i));
end

% convert pixel to physical units
for i = 1 : ncam
    nparticle = size(pos2D{i}, 1);
    map{i} = ParticlePositionMap(cam(i), pos2D{i}); % generate position map
    for j = 1 : nparticle
        pos2D_mm{i}(j, :) = cam(i).UnDistort([pos2D{i}(j,:), 0]);
    end
end

n = 1; 
matches = [0 0 0 0];
for i = 1 : size(pos2D_mm{1}, 1)
    pos1 = pos2D_mm{1}(i, :);
    pos1_3D = cam(1).ImageToWorld(pos1');
%     radii_mm = norm(cam(1).UnDistort([radii{1}(i) + 1, 1, 0]) - cam(1).UnDistort([1, 1, 0])); 
%     mindist_2D = radii_mm * 2;
    part_candidate_cam2 = ParticleFinder1To1(cam(1), cam(2), pos1_3D, mindist_2D, map{2}, pos2D_mm{2}, img{2});
    if isempty(part_candidate_cam2)
        continue;
    end
    
    for ii = 1 :  length(part_candidate_cam2)
        pos2 = pos2D_mm{2}(part_candidate_cam2(ii), :);
        pos2_3D = cam(2).ImageToWorld(pos2');
        part_candidate_cam3 = ParticleFinder2To1(cam(1), cam(2), cam(3), pos1_3D, pos2_3D, mindist_2D, map{3}, pos2D_mm{3}, img{3});
        if isempty(part_candidate_cam3)
            continue;
        end
        
        for iii = 1 :  length(part_candidate_cam3)
            pos3 = pos2D_mm{3}(part_candidate_cam3(iii), :);
            pos3_3D = cam(3).ImageToWorld(pos3');
            % projecting them back to cam1 and cam2 and check
            if ParticleCheck2To1(cam(2), cam(3), cam(1), pos2_3D, pos3_3D, pos1, mindist_2D) && ...
                    ParticleCheck2To1(cam(1), cam(3), cam(2), pos1_3D, pos3_3D, pos2, mindist_2D)
                if (ncam < 4) 
                    matches(n, :) = [i, part_candidate_cam2(ii), part_candidate_cam3(iii), 0];
                    n = n + 1;
                    continue;
                end
                part_candidate_cam4 = ParticleFinder2To1(cam(2), cam(3), cam(4), pos2_3D, pos3_3D, mindist_2D, map{4}, pos2D_mm{4}, img{4});
                if isempty(part_candidate_cam4)
                    continue;
                end
                    for iiii = 1 : length(part_candidate_cam4)
                        % check whether the candidate from intersection of cam2 and
                        % cam4 callapse with particle on cam1
                        pos4 = pos2D_mm{4}(part_candidate_cam4(iiii), :);
                        pos4_3D = cam(4).ImageToWorld(pos4');    
                        if ParticleCheck1To1(cam(4), cam(1), pos4_3D, pos1, mindist_2D)   
                            if ParticleCheck2To1(cam(3), cam(4), cam(1), pos3_3D, pos4_3D, pos1, mindist_2D) && ...
                                    ParticleCheck2To1(cam(3), cam(4), cam(2), pos3_3D, pos4_3D, pos2, mindist_2D) && ...
                                    ParticleCheck2To1(cam(1), cam(4), cam(3), pos1_3D, pos4_3D, pos3, mindist_2D) && ...
                                    ParticleCheck2To1(cam(1), cam(2), cam(4), pos1_3D, pos2_3D, pos4, mindist_2D)
                                matches(n, :) = [i, part_candidate_cam2(ii), part_candidate_cam3(iii), part_candidate_cam4(iiii)];
                                n = n + 1;
                            end
                        end
                    end
            end
        end
    end
end

num_match = size(matches, 1);
matches_pos2D = zeros(num_match, 8);
for i = 1 : ncam
    matches_pos2D(:, i * 2 - 1 : i * 2) = pos2D{i}(matches(:, i), :);
end

matches_pos3D = zeros(num_match, 3);
tri_err = zeros(num_match, 1);
mean_radii = zeros(num_match, 1);
std_radii  = zeros(num_match, 1);
for i = 1 : num_match
    [position3D, error] = Triangulation(cam, matches_pos2D(i, :));
    matches_pos3D(i, :) = position3D;
    tri_err(i) = error;
    mean_radii(i) = mean([radii{1}(matches(i, 1)), radii{2}(matches(i, 2)),  radii{3}(matches(i, 3))]); %radii{4}(matches(i, 4))]);
    std_radii(i) = std([radii{1}(matches(i, 1)), radii{2}(matches(i, 2)),  radii{3}(matches(i, 3))]);%, radii{4}(matches(i, 4))]);
end
end

function map = ParticlePositionMap(cam, pos2D)
    npixw = cam.camParaCalib.Npixw;
    npixh = cam.camParaCalib.Npixh;
    map = zeros(npixh, npixw);
    
    for i = 1 : size(pos2D, 1)
        x = round(pos2D(i, 1));
        y = round(pos2D(i, 2));
        if (x > npixw - 1 || y > npixh - 1 || x < 0 || y < 0)
            continue;
        end
        map(y, x) = i;
    end
end

function particles_index = ParticleFinder1To1(cam1, cam2, pos, mindist_2D, map, pos2D_mm, img)

    center_cam1_on_cam2 = cam2.WorldToImage(cam1.Center());
    pos_3D_on_cam2 = cam2.WorldToImage(pos);
    slope_lineofsight = pos_3D_on_cam2 - center_cam1_on_cam2;
    slope_lineofsight = slope_lineofsight / norm(slope_lineofsight);
    perp_slop = [slope_lineofsight(2), -slope_lineofsight(1), 0];
    
    a = (center_cam1_on_cam2(2) - pos_3D_on_cam2(2)) / (center_cam1_on_cam2(1) - pos_3D_on_cam2(1));
    b = pos_3D_on_cam2(2) - a * pos_3D_on_cam2(1);
    linepara = [a, b];
%     figure;
%     imshow(img);
%     p1 = [-50 a*(-50) + b 0]; p2 = [50 a * 50 + b 0];
%     p1 = cam2.Distort(p1); p2 = cam2.Distort(p2);
%     p = [p1; p2];
%     hold on
%     plot(p(:,1), p(:,2), 'r-');
    if abs(a) >= 1
        npix = cam2.camParaCalib.Npixh;
    else
        npix = cam2.camParaCalib.Npixw;
    end
    
    particles_index = [];
    n = 1;
    for pix = 1 : npix     
        if abs(a) >= 1 % scan in y-direction
            ypix = pix;
            [xpix_min, xpix_max] = PixelSearchX(cam2, linepara, mindist_2D, ypix);
             if xpix_min == 0 || xpix_max == 0
                continue;
             end
%              hold on
%             plot(xpix_min, ypix, 'r.')
%             plot(xpix_max, ypix, 'r.')
            for xpix = ceil(xpix_min) : ceil(xpix_max)
                if map(ypix, xpix) > 0
                    pos2D = pos2D_mm(map(ypix, xpix), :)';
                    if abs(dot(pos2D - center_cam1_on_cam2, perp_slop)) < mindist_2D
                        particles_index(n) = map(ypix, xpix);
                        n = n + 1;
                    end
                end
            end
        else
            xpix = pix;
            [ypix_min, ypix_max] = PixelSearchY(cam2, linepara, mindist_2D, xpix);
            if ypix_min == 0 || ypix_max == 0
                continue;
            end
%             hold on
%             plot(xpix, ypix_min, 'r.')
%             plot(xpix, ypix_max, 'r.')
            for ypix = ceil(ypix_min) : ceil(ypix_max)
                if map(ypix, xpix) > 0
                    pos2D = pos2D_mm(map(ypix, xpix), :);
                    if abs(dot(pos2D' - center_cam1_on_cam2, perp_slop)) < mindist_2D
                        particles_index(n) = map(ypix, xpix);
                        n = n + 1;
                    end
                end
            end            
        end
    end
    
%     pos2D = pos2D_mm(particles_index, :);
%         pos2D_pixel = [];
%     for i = 1:size(pos2D,1)
%         pos2D_pixel(i, :) = cam2.Distort(pos2D(i, :));
%     end
%     hold on;
%     if ~isempty(pos2D_pixel)
%     plot(pos2D_pixel(:,1), pos2D_pixel(:,2), 'go');
%     end
%     
%     for i = 1:size(pos2D_mm,1)
%         pos2D_pixel(i, :) = cam2.Distort(pos2D_mm(i, :));
%     end
%      plot(pos2D_pixel(:,1), pos2D_pixel(:,2), 'y.');
%     hold off;
end

function particles_index = ParticleFinder2To1(cam1, cam2, cam3, pos1, pos2, mindist_2D, map, pos2D_mm, img)
% pos1 from cam1 onto cam3
    center_cam1_on_cam3 = cam3.WorldToImage(cam1.Center());
    pos1_3D_on_cam3 = cam3.WorldToImage(pos1);
    a1 = (center_cam1_on_cam3(2) - pos1_3D_on_cam3(2)) / (center_cam1_on_cam3(1) - pos1_3D_on_cam3(1));
    b1 = pos1_3D_on_cam3(2) - a1 * pos1_3D_on_cam3(1);
    
%         imshow(img);
%     p1 = [-50 a1*(-50) + b1 0]; p2 = [50 a1 * 50 + b1 0];
%     p1 = cam2.Distort(p1); p2 = cam2.Distort(p2);
%     p = [p1; p2];
%     hold on
%     plot(p(:,1), p(:,2), 'r-');
    
% pos2 from cam2 onto cam3
    center_cam2_on_cam3 = cam3.WorldToImage(cam2.Center());
    pos2_3D_on_cam3 = cam3.WorldToImage(pos2);
    a2 = (center_cam2_on_cam3(2) - pos2_3D_on_cam3(2)) / (center_cam2_on_cam3(1) - pos2_3D_on_cam3(1));
    b2 = pos2_3D_on_cam3(2) - a2 * pos2_3D_on_cam3(1);
    
%         p1 = [-50 a2*(-50) + b2 0]; p2 = [50 a2 * 50 + b2 0];
%     p1 = cam2.Distort(p1); p2 = cam2.Distort(p2);
%     p = [p1; p2];
%     hold on
%     plot(p(:,1), p(:,2), 'r-');
    
    % the angle between two lines, the mindist depends on the angle
    theta1 = atan(a1) * (180 / pi);
    theta2 = atan(a2) * (180 / pi);
    angle = abs(theta1 - theta2);
    if angle > 180
        angle = 360 - angle;
    end
    mindist = abs(mindist_2D / sin(pi *  angle / 360));
%     if mindist > 1200 * 0.04
%         mindist = 1200 * 0.04;
%     end
if (mindist > mindist * 3) 
		mindist = mindist * 3;
end
    
    % the intersection point
    x = (b2 - b1) / (a1 - a2);
    y = a1 * x + b1;
    p = [x, y, 0];
    p1 = [x - mindist, y - mindist, 0];
    p2 = [x + mindist, y + mindist, 0];
    p1_pixel = cam3.Distort(p1);
    p2_pixel = cam3.Distort(p2);
    xpix1 = floor(p1_pixel(1)); 
    xpix2 = ceil(p2_pixel(1));
    ypix1 = ceil(p1_pixel(2));
    ypix2 = floor(p2_pixel(2));
    npixw = cam3.camParaCalib.Npixw;
    npixh = cam3.camParaCalib.Npixh;
    particles_index = [];
    if (xpix1 > 0 && xpix1 <= npixw) ||...
            (xpix2 > 0 && xpix2 <= npixw) || ...
            (ypix1 > 0 && ypix1 <= npixh) ||...
            (ypix2 > 0 && ypix2 <= npixh)
        xpix1 = max(1, xpix1);
        ypix2 = max(1, ypix2);
        xpix2 = min(npixw, xpix2);
        ypix1 = min(npixh, ypix1);
        
        n = 1;
        for xpix = xpix1 : xpix2
            for ypix = ypix2 : ypix1
                if (map(ypix, xpix) > 0)
                    pos2D = pos2D_mm(map(ypix, xpix), :);
                    if norm(pos2D - p) < mindist
                        dist1 = abs(-a1 * pos2D(1) + pos2D(2) - b1) / ( 1 + a1^2)^.5;
                        dist2 = abs(-a2 * pos2D(1) + pos2D(2) - b2) / ( 1 + a2^2)^.5;
                        if dist1 < mindist_2D && dist2 < mindist_2D
                            particles_index(n) = map(ypix, xpix);
                            n = n + 1;
                        end
                    end
                end
            end
        end
    end
%     pos2D = pos2D_mm(particles_index, :);
%     pos2D_pixel = [];
%     for i = 1:size(pos2D,1)
%         pos2D_pixel(i, :) = cam2.Distort(pos2D(i, :));
%     end
%     hold on;
%     if ~isempty(pos2D_pixel)
%     plot(pos2D_pixel(:,1), pos2D_pixel(:,2), 'go');
%     end
end

function is_candidate = ParticleCheck2To1(cam1, cam2, cam3, pos1, pos2, pos3, mindist_2D)
    % pos1 from cam1 onto cam3
    center_cam1_on_cam3 = cam3.WorldToImage(cam1.Center());
    pos1_3D_on_cam3 = cam3.WorldToImage(pos1);
    a1 = (center_cam1_on_cam3(2) - pos1_3D_on_cam3(2)) / (center_cam1_on_cam3(1) - pos1_3D_on_cam3(1));
    b1 = pos1_3D_on_cam3(2) - a1 * pos1_3D_on_cam3(1);
    
% pos2 from cam2 onto cam3
    center_cam2_on_cam3 = cam3.WorldToImage(cam2.Center());
    pos2_3D_on_cam3 = cam3.WorldToImage(pos2);
    a2 = (center_cam2_on_cam3(2) - pos2_3D_on_cam3(2)) / (center_cam2_on_cam3(1) - pos2_3D_on_cam3(1));
    b2 = pos2_3D_on_cam3(2) - a2 * pos2_3D_on_cam3(1);
    
    % the angle between two lines, the mindist depends on the angle
    theta1 = atan(a1) * (180 / pi);
    theta2 = atan(a2) * (180 / pi);
    angle = abs(theta1 - theta2);
    if angle > 180
        angle = 360 - angle;
    end
    mindist = abs(mindist_2D / sin(pi *  angle / 360));
%     if mindist > 1200 * 0.04
%         mindist = 1200 * 0.04;
%     end
    if (mindist > mindist * 3) 
		mindist = mindist * 3;
end
    
        % the intersection point
    x = (b2 - b1) / (a1 - a2);
    y = a1 * x + b1;
    p = [x, y, 0];
    
    is_candidate = false;
    dist = norm(pos3 - p);
    if dist < mindist
        dist1 = abs(-a1 * pos3(1) + pos3(2) - b1) / ( 1 + a1^2)^.5;
        dist2 = abs(-a2 * pos3(1) + pos3(2) - b2) / ( 1 + a2^2)^.5;
        if dist1 < mindist_2D && dist2 < mindist_2D
            is_candidate = true;
        end
    end
end

function is_candidate = ParticleCheck1To1(cam1, cam2, pos1, pos2, mindist_2D)
    center_cam1_on_cam2 = cam2.WorldToImage(cam1.Center());
    pos_3D_on_cam2 = cam2.WorldToImage(pos1);
    direction = pos_3D_on_cam2 - center_cam1_on_cam2;
    direction = direction / norm(direction);
    perp = [direction(2), -direction(1), 0];
    
    is_candidate = false;
    line2 = pos2 - center_cam1_on_cam2';
    if abs(dot(line2, perp)) < mindist_2D
        is_candidate = true;
    end
end

function [position3D, error] = Triangulation(cam, position2D) 
A = zeros(3, 3);
B = zeros(3, 1);
D = 0;
for i = 1 : size(cam,2)
    % get the world position of the point on the image
    %SIpos = Img2World(camParaCalib(i), UnDistort(position2D((i - 1) * 2 + 1 : (i - 1) * 2 + 2), camParaCalib(i))); 
    SIpos = cam(i).UnDistort([position2D((i - 1) * 2 + 1 : (i - 1) * 2 + 2), 0]);
    SIpos = cam(i).ImageToWorld(SIpos');
    % get the vector 
    sight = SIpos - cam(i).camParaCalib.Tinv;
    sight = sight / norm(sight); 
    C = eye(3) - sight *  sight';
    A = A + C;
    B = B + C * cam(i).camParaCalib.Tinv;
    D = D + cam(i).camParaCalib.Tinv' * C * cam(i).camParaCalib.Tinv;
end
position3D = A \ B;
error = (position3D' * A * position3D - 2 * position3D' * B + D) ^ .5 / 4;
end

function [pix_min, pix_max] = PixelSearchX(cam, linepara, mindist_2D, pix)
        theta = atan(- 1 / linepara(1));
        b_plus = linepara(2) + mindist_2D * ( sin(theta) - linepara(1) * cos(theta));
        b_minus = linepara(2) - mindist_2D * ( sin(theta) - linepara(1) * cos(theta));
        pix_min = 0;
        pix_max = 0;
        if linepara(1) > 0
            x_a = Xpix1(cam, linepara(1), linepara(2), pix);
            x_b = Xpix1(cam, linepara(1), b_plus, pix);
            x_c = Xpix1(cam, linepara(1), b_minus, pix);
        else
            x_a = Xpix2(cam, linepara(1), linepara(2), pix);
            x_b = Xpix2(cam, linepara(1), b_plus, pix);
            x_c = Xpix2(cam, linepara(1), b_minus, pix);
        end
        xpix_a = x_a;
        if xpix_a >= 0 && xpix_a <= cam.camParaCalib.Npixw
            ypix_b = min(max(1, x_b), cam.camParaCalib.Npixw - 1);
            ypix_c = min(max(1, x_c), cam.camParaCalib.Npixw - 1);
            pix_min = min(ypix_b, ypix_c) - 1;
            pix_max = max(ypix_b, ypix_c);
            pix_max = min(pix_max, cam.camParaCalib.Npixw - 2) + 2;
        end
    end

function [pix_min, pix_max] = PixelSearchY(cam, linepara, mindist_2D, pix)
        theta = atan(- 1 / linepara(1));
        b_plus = linepara(2) + mindist_2D * ( sin(theta) - linepara(1) * cos(theta));
        b_minus = linepara(2) - mindist_2D * ( sin(theta) - linepara(1) * cos(theta));
        pix_min = 0;
        pix_max = 0;
        
        y_a = Ypix1(cam, linepara(1), linepara(2), pix);
        y_b = Ypix1(cam, linepara(1), b_plus, pix);
        y_c = Ypix1(cam, linepara(1), b_minus, pix);

        ypix_a = y_a;
        if ypix_a >= 0 && ypix_a <= cam.camParaCalib.Npixh
            ypix_b = min(max(1, y_b), cam.camParaCalib.Npixh - 1);
            ypix_c = min(max(1, y_c), cam.camParaCalib.Npixh - 1);
            pix_min = min(ypix_b, ypix_c) - 1;
            pix_max = max(ypix_b, ypix_c);
            pix_max = min(pix_max, cam.camParaCalib.Npixh - 2) + 2;
        end
    end

function x =Xpix1(cam, a, b, pix)
        Y = (-pix + cam.camParaCalib.Npixh / 2 - cam.camParaCalib.Noffh) * cam.camParaCalib.hpix;
        if cam.camParaCalib.k1 == 0
            x = -b + Y / a;
        else
            c = b * (a^2 - 4 * Y^2 * cam.camParaCalib.k1 * ( 1 + a^2 + cam.camParaCalib.k1 * b^2) + 4 * Y * b * cam.camParaCalib.k1 * a) ^.5;
            x = (-b * a + 2 * Y * a - c) / (2 * (cam.camParaCalib.k1 * b^2 + a^2));
        end
        x = (cam.camParaCalib.Npixw / 2 - cam.camParaCalib.Noffw) + x / cam.camParaCalib.wpix;
    end

function x =Xpix2(cam, a, b, pix)
        Y = (-pix + cam.camParaCalib.Npixh / 2 - cam.camParaCalib.Noffh) * cam.camParaCalib.hpix;
        if cam.camParaCalib.k1 == 0
            x = -b + Y / a;
        else
            c = b * (a^2 - 4 * Y^2 * cam.camParaCalib.k1 * ( 1 + a^2 + cam.camParaCalib.k1 * b^2) + 4 * Y * b * cam.camParaCalib.k1 * a) ^.5;
            x = (-b * a + 2 * Y * a + c) / (2 * (cam.camParaCalib.k1 * b^2 + a^2));
        end
        x = (cam.camParaCalib.Npixw / 2 - cam.camParaCalib.Noffw) + x / cam.camParaCalib.wpix;
    end

function y = Ypix1(cam, a, b, pix)
         X = (pix - cam.camParaCalib.Npixw / 2 + cam.camParaCalib.Noffw) * cam.camParaCalib.wpix;
        if cam.camParaCalib.k1 == 0
            y = a * X + b;
        else
            c = b * (1 - 4 * X^2 * cam.camParaCalib.k1 * ( 1 + a^2 + cam.camParaCalib.k1 * b^2) - 4 * X * b * cam.camParaCalib.k1 * a) ^.5;
            y = (b + 2 * X * a + c) / (2 * (cam.camParaCalib.k1 * b^2 + 1));
        end
        y = (cam.camParaCalib.Npixh / 2 - cam.camParaCalib.Noffh) - y / cam.camParaCalib.hpix;       
    end
