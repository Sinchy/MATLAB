%% read images

img(1, :, :) = imread('D:\1.Projects\2.Bubble-Particle\Data_analysis\Image_processing\022421\Run1\cam_1\cam1frame000001.tif');
img(2, :, :) = imread('D:\1.Projects\2.Bubble-Particle\Data_analysis\Image_processing\022421\Run1\cam_2\cam2frame000001.tif');
img(3, :, :) = imread('D:\1.Projects\2.Bubble-Particle\Data_analysis\Image_processing\022421\Run1\cam_3\cam3frame000001.tif');
img(4, :, :) = imread('D:\1.Projects\2.Bubble-Particle\Data_analysis\Image_processing\022421\Run1\cam_4\cam4frame000001.tif');

%% get 2D centers of bubbles
for i = 1 : 4
    [~, hpix, wpix] = size(img);
    img0 = reshape(img(i, :, :), hpix, wpix) > 40; % change it to binary image
    stats = regionprops('table',img0,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    bubble_label = radii > 3; 
    pos2D{i} = centers(bubble_label == 1, :);
    radii_bubble{i} = radii(bubble_label == 1);
end

%% output 2D centers
file_path = 'D:\1.Projects\2.Bubble-Particle\Data_analysis\Image_processing\022421\Run1\';
  for i = 1 : 4
        pos2D_to_output = reshape(pos2D{i}', [size(pos2D{i}, 1) * 2, 1]);
        fileID = fopen([file_path 'cam_' num2str(i) '/' 'cam' num2str(i) 'frame000001.txt'], 'w');
        fprintf(fileID, '%6.4f,', pos2D_to_output);
        fclose(fileID);
    end

%% run stereomatching
[matches_pos3D, mean_radii, tri_err, matches_pos2D] = StereoMatching(pos2D,  radii_bubble, camParaCalib);

%% plot the matches on images
for i = 1 : length(matches)
    label{i} = num2str(i);
end
[n, m] = size(matches);
radii_bbs = zeros(n, m);
for i = 1 : 4
    figure
    imshow(reshape(img(i,:,:), 800, 1280))
    hold on
    pos2D_to_plot = pos2D{i}(matches(:,i), :);
    plot(pos2D_to_plot(:,1), pos2D_to_plot(:,2), 'r.');
    text(pos2D_to_plot(:,1), pos2D_to_plot(:,2), label, 'VerticalAlignment','bottom','Color','yellow');
    radii_bbs(:, i) = radii_bubble{i}(matches(:,i));
end

%% Shaking
image_dir = 'D:\1.Projects\2.Bubble-Particle\Data_analysis\Image_processing\022421\Run1\';
frame_num = 1;
shake_point = PositionRefine(matches_pos3D, mean_radii, image_dir, frame_num, camParaCalib);

%% Compare 
figure
imshow(uint8(reshape(img(1,:,:), 800, 1280)))
hold on
plot(pos2D_bfShaking(:,1), pos2D_bfShaking(:,2), 'r.');
plot(pos2D_afShaking(:,1), pos2D_afShaking(:,2), 'g.');