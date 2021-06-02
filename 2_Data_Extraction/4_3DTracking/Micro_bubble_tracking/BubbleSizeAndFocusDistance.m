function focus_dist_rad = BubbleSizeAndFocusDistance(camParaCalib, track, img)
ncam = size(camParaCalib, 1);
nframe = size(track, 1);

for i = 1 : ncam
    cam_pos = (camParaCalib(i).R \ ( - camParaCalib(i).T))' ; %unit: mm
    cam_vec(i, :) = cam_pos / norm(cam_pos);
end

[~, ~, h, w] = size(img);
focus_dist_rad = zeros(nframe, ncam,  2);
for i = 1 : nframe
    for j = 1 : ncam
        focus_dist = abs(dot(track(i, 1 : 3), cam_vec(j, :)));
        [centers, radius] = ObtainBubble2DCenterSize(reshape(img(i, j, :, :), [h, w]));
        if size(centers, 1) > 1
            [~, index] = min(vecnorm(centers - [h, w] / 2, 2, 2));
            radius =radius(index);
        end
        if isempty(radius)
            radius = 0;
        end
        focus_dist_rad(i, j, :) = [focus_dist, radius];
    end
end
end

