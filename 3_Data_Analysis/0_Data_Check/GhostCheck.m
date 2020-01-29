% function ghost_percent = GhostCheck(tracked, calib, image_path, frame_num)
function [ghost_percent, ghost_mark] = GhostCheck(original, tracked)
% tracked = RemovRepeatedPart(tracked);
num_particle = size(tracked, 1);
ghost = 0;
tolerant = 0.05;
ghost_mark = zeros(num_particle, 1);
for i = 1 : num_particle
    point =  tracked(i, 1 : 3);
    candidate = original(original(:, 1) > point(1) - tolerant & original(:, 1) < point(1) + tolerant & ...
            original(:, 2) > point(2) - tolerant & original(:, 2) < point(2) + tolerant & ...
            original(:, 3) > point(3) - tolerant & original(:, 3) < point(3) + tolerant, :);
    diff = vecnorm(candidate(:, 1 : 3) - tracked(i, 1 : 3), 2, 2);
    if ~sum(diff < 0.04) 
        ghost = ghost + 1;
        ghost_mark(i) = 1;
    end
end
% for i = 1 : 4
%     img_all(:,:,i) = imread([image_path  'cam' num2str(i) '/cam' num2str(i) 'frame' num2str(frame_num, '%05.0f') '.tif']);
% end
% for i = 1 : num_particle
%     exist = 0;
%     for j = 1 : 4
%         position2D = round(calibProj_Tsai(calib(j), tracked(i, 1:3)));
%         img = reshape(img_all(:, :, j), [ 1024 1024]);
%         if sum(img(max(1,position2D(2) - 1) : min(1024,position2D(2) + 1), max(1,position2D(1) - 1) : min(1024,position2D(1) + 1)) > 30)
%             exist = exist + 1;
%         end  
%     end
%     if exist < 2
%         ghost = ghost + 1;
%     end
% end

ghost_percent = ghost / size(original, 1);
end

function particles = RemovRepeatedPart(particles)
repeated = zeros(size(particles, 1), 1);
for i = 1 : size(particles, 1)
    if ~repeated(i, 1)
        diff = vecnorm(particles(i, 1:3) - particles(:, 1:3), 2, 2);
        ind = diff < 0.04;
        repeated(ind,1) = 1;
        repeated(i,1) = 0;
    end
end
particles(repeated == 1, :) = [];
end


