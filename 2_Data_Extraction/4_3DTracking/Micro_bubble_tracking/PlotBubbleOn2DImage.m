frame = 30000;
cam = 1;
prj_path = 'C:\Users\ShiyongTan\Documents\Data_processing\20220204\T3\S1';
img = imread([prj_path '\cam_' num2str(cam) '\cam' num2str(cam) 'frame' num2str(frame, '%06.0f') '.tif']);
%% 
tracks = sortrows(tracks, 5);
particles = tracks(tracks(:, 4) == frame, :);
r_p = radius(ismember(radius(:,1), particles(:,5)) , :);
circle = calibProj(camParaCalib(cam), particles(:, 1:3));

%%
figure
imshow(img)
hold on
viscircles(circle, r_p(:, 2));

