function [wandpts, radius] = WandPoints(imgdir, r_range, frame_range, skip_frame)
ncams = 3;
num_frame = round( (frame_range(2) - frame_range(1)) / skip_frame);
wandpts = zeros(num_frame, ncams * 4);
radius = zeros(num_frame, ncams * 2);
frame = 1; 
f = waitbar(0, 'Processing');
for i = frame_range(1) : skip_frame: frame_range(2)
    cam = 1;
    for j = 1:ncams
        img = imread([imgdir '\Cam' num2str(j) '\cam' num2str(j) 'frame' num2str(i, '%06.0f' ) '.tif']);
        img = uint8(255) - img;
        [centers, radii] = imfindcircles(img, r_range, 'Sensitivity', .85);
        if length(radii) ~=2
            cam = cam + 1;
            continue;
        end
        if radii(1) < radii(2)
            wandpts(frame, (cam - 1) * 4 + 1: (cam - 1) * 4 + 2) = centers(1, :);
            wandpts(frame, (cam - 1) * 4 + 3: (cam - 1) * 4 + 4) = centers(2, :);
            radius(frame, (cam - 1) * 2 + 1 : (cam -1) * 2 + 2) = [radii(1), radii(2)];
        else
            wandpts(frame, (cam - 1) * 4 + 1: (cam - 1) * 4 + 2) = centers(2, :);
            wandpts(frame, (cam - 1) * 4 + 3: (cam - 1) * 4 + 4) = centers(1, :);
            radius(frame, (cam - 1) * 2 + 1 : (cam -1) * 2 + 2) = [radii(2), radii(1)];
        end
        cam = cam + 1;
    end
    frame = frame + 1;
    waitbar(frame/num_frame, f);
end

index = any(wandpts == 0, 2);
wandpts(index, :) = [];
radius(index, :) = [];
pt1_index = zeros(1, 2 * ncams);
pt2_index = zeros(1, 2 * ncams);
for i = 1 :ncams
    pt1_index((i - 1) * 2 + 1 : (i - 1) * 2 + 2) =  [(i-1) .* 4 + 1, (i-1) .* 4 + 2];
    pt2_index((i - 1) * 2 + 1 : (i - 1) * 2 + 2) =  [(i-1) .* 4 + 3, (i-1) .* 4 + 4];
end
wandpts = wandpts(:, [pt1_index pt2_index]);
end

