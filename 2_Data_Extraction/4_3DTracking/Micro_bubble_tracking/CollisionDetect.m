%% get the tracks
i = 5;
track1 = tracks(tracks(:,5) == collision(i,1), :);
track2 = tracks(tracks(:, 5) == collision(i, 2), :);
track_collision = [track1; track2];
PlotTracks(track_collision)
%%
radius1 = radius(radius(:, 1) == track1(1,5), 2);
radius2 = radius(radius(:, 1) == track2(1,5), 2);
imgdir = 'D:\1.Projects\2.Bubble-Particle\Data_analysis\Data_processing\20211203\T2\S3\';
[~, img_overlap1] = GetImageOnTracks(imgdir , track1, radius1,camParaCalib, 1);
[~, img_overlap2] = GetImageOnTracks(imgdir , track2, radius2,camParaCalib, 1);
%%
img_overlap = img_overlap1(3, :, :) + img_overlap2(3, :, :);
img_overlap(img_overlap > 255) = 255;
img_overlap = reshape(img_overlap, 800, 1280);
figure;
imshow(img_overlap)