function [img_bubble, img_overlap] = GetImageOnTracks(imgdir, track, camParaCalib, skip_frame)
ncam = size(camParaCalib, 1);

% cam = cell(ncam, 1);
for i = 1 : ncam
    cam(i) = Camera(camParaCalib(i));
end

%% get the size of the bubble
frame = track(1, 4);
img = imread([imgdir 'cam_1/cam1frame' num2str(frame,'%06.0f') '.tif']);
[hpix, wpix] = size(img);
[centers, radii] = ObtainBubble2DCenterSize(img);
pos2D_mm =cam(1).WorldToImage(track(1, 1:3)');
pos2D = cam(1).Distort(pos2D_mm);
dist = vecnorm(centers - pos2D(1:2), 2, 2);

[dist_min, index]= min(dist);
if dist_min > radii(index)
    warning('The found particle may be wrong.');
end
bubble_size = radii(index);
image_size = round(bubble_size * 3);

%% 
n_frame = size(track, 1);
img_bubble = uint8(zeros(ceil(n_frame / skip_frame), ncam, image_size, image_size));
img_overlap = uint8(zeros(ncam, hpix, wpix));

for i = 1 : skip_frame:n_frame
    for j = 1 : ncam
        img = imread([imgdir 'cam_' num2str(j) '/cam' num2str(j) 'frame' num2str(track(i, 4),'%06.0f') '.tif']);
        pos2D_mm =cam(j).WorldToImage(track(i, 1:3)');
        pos2D = cam(j).Distort(pos2D_mm);
        x_min = max(1, round(pos2D(1) - image_size / 2));
        y_min = max(1, round(pos2D(2) - image_size / 2));
        x_max = min(wpix, round(pos2D(1) + image_size / 2));
        y_max = min(hpix, round(pos2D(2) + image_size / 2));
        if x_min > wpix || y_min > hpix || x_max < 1 || y_max < 1
            continue;
        end
        img_bubble(i, j, 1 : y_max - y_min,1 : x_max - x_min) = img(y_min : y_max - 1, x_min : x_max - 1);
        img_overlap(j, y_min : y_max - 1, x_min : x_max - 1) = max(reshape(img_overlap(j, y_min : y_max - 1, x_min : x_max - 1), [ y_max - y_min, x_max - x_min]), img(y_min : y_max - 1, x_min : x_max - 1));
    end
end
end

