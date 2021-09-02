function [wandpts, radius] = WandPoints(imgdir, r_range, frame_range, skip_frame)
ncams = 3;
num_frame = round( (frame_range(2) - frame_range(1)) / skip_frame);
% wandpts = zeros(num_frame, ncams * 4);
% radius = zeros(num_frame, ncams * 2);
wandpts = cell(num_frame, 1);
radius = cell(num_frame, 1);
% frame = 1; 
% f = waitbar(0, 'Processing');
h = parpool(16);
parfor i = frame_range(1) : skip_frame: frame_range(2)
%     cam = 1;
    pts = zeros(1, ncams * 4);
    r = zeros(1, ncams * 2);
    is_zero = 0;
    for j = 1:ncams
        img = imread([imgdir '\Cam' num2str(j) '\cam' num2str(j) 'frame' num2str(i, '%06.0f' ) '.tif']);
        img = uint8(255) - img;
        [centers, radii] = imfindcircles(img, r_range, 'Sensitivity', .85);
        if length(radii) ~=2
            is_zero = 1;
            break;
        end
         
        if radii(1) < radii(2)
            pts(1, (j - 1) * 4 + 1: (j - 1) * 4 + 2) = centers(1, :);
            pts(1, (j - 1) * 4 + 3: (j - 1) * 4 + 4) = centers(2, :);
            r(1, (j - 1) * 2 + 1 : (j -1) * 2 + 2) = [radii(1), radii(2)];
        else
            pts(1, (j - 1) * 4 + 1: (j - 1) * 4 + 2) = centers(2, :);
            pts(1, (j - 1) * 4 + 3: (j - 1) * 4 + 4) = centers(1, :);
            r(1, (j - 1) * 2 + 1 : (j -1) * 2 + 2) = [radii(2), radii(1)];
        end
%         cam = cam + 1;
    end
    if ~is_zero
        wandpts{i} = pts;
        radius{i} = r;
    end
%     frame = frame + 1;
%     waitbar(frame/num_frame, f);
end

delete(h);
% index = any(wandpts == 0, 2);
% wandpts(index, :) = [];
% radius(index, :) = [];
pt1_index = zeros(1, 2 * ncams);
pt2_index = zeros(1, 2 * ncams);
for i = 1 :ncams
    pt1_index((i - 1) * 2 + 1 : (i - 1) * 2 + 2) =  [(i-1) .* 4 + 1, (i-1) .* 4 + 2];
    pt2_index((i - 1) * 2 + 1 : (i - 1) * 2 + 2) =  [(i-1) .* 4 + 3, (i-1) .* 4 + 4];
end
wandpts = cell2mat(wandpts);
radius = cell2mat(radius);
wandpts = wandpts(:, [pt1_index pt2_index]);
end

