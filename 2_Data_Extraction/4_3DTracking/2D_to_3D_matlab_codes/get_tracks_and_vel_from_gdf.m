% Images with tracks
% 
dirr = ['C:\Users\aks5577\Desktop\cam_config_of_04.04.18\ProcessedImages\04.12.18\Bubbles3\noBubbles_200frLaVImgProcess\'];
% dirr = 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\straight_line_track\';
% cam_dir = {dirr, dirr, dirr, dirr};
cam_dir = {[dirr 'cam1_corrected\'], [dirr 'cam2_corrected\'], [dirr 'cam3\'], [dirr 'cam4\'], [dirr 'cam5\'], [dirr 'cam6\']}; 


tr_images = zeros(1024,1024,6);
for i = 1:4
    for frame = 1:200
        img = imread([cam_dir{i} 'cam' num2str(i) 'frame' num2str(frame,'%04.0f') '.tif']);
        tr_images(:,:,i) = max(tr_images(:,:,i),double(img));
    end
end

%% getting tracks

tr1 = read_gdf('tracks_cam1.gdf');
tr2 = read_gdf('tracks_cam2.gdf');
tr3 = read_gdf('tracks_cam3.gdf');
tr4 = read_gdf('tracks_cam4.gdf');

%% removing small tracks

thresh = 10;
for i = 1:4
    eval(['tr_long = tr' num2str(i) ';']);
    [a,b] = histc(tr_long(:,1),unique(tr_long(:,1)));
    y = a(b);

    tr_long(y<thresh,:) = [];
    eval(['tr' num2str(i) '_long = tr_long;']);
end
%% plot
figure; imshow(uint8(tr_images(:,:,1))); hold on; plot(tr1_long(:,2),tr1_long(:,3),'r.');
figure; imshow(uint8(tr_images(:,:,2))); hold on; plot(tr2_long(:,2),tr2_long(:,3),'r.');
figure; imshow(uint8(tr_images(:,:,3))); hold on; plot(tr3_long(:,2),tr3_long(:,3),'r.');
figure; imshow(uint8(tr_images(:,:,4))); hold on; plot(tr4_long(:,2),tr4_long(:,3),'r.');

%% get tracks with velocity in pix / s
fitWidth = 6;
filtWidth = 2;
framerate = 4000; %fps

for i = 1:1
    eval(['vel_cam' num2str(i) '= rni_vel_acc_2D(tr' num2str(i) '_long,filtWidth,fitWidth,framerate);']);
    eval(['vel_mag = sqrt(sum(vel_cam' num2str(i) '(:,5:6).^2,2));']);
    eval(['vel_cam' num2str(i) '(:,9) = vel_mag;']);
end
