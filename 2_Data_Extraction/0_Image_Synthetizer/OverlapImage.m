% dirr = '/home/shiyongtan/Documents/Experiment/EXP16/';
dirr = '/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072618/';
tr_img = zeros(1024,1024,6);
for cam = 5
    for frame = 1:1000
%         img = double(imread([dirr 'cam' num2str(cam) '/cam' num2str(cam) 'frame' num2str(frame,'%04.0f') '.tif']));
        img = double(imread([dirr 'cam' num2str(cam) '/cam' num2str(cam) 'frame' num2str(frame,'%04.0f') '.tif']));
        tr_img(:,:,cam) = max(tr_img(:,:,cam),img);
    end
end

tr_img = uint8(tr_img);
 figure; 
imshow(tr_img(:,:,5)); % plot the overlapping image of cam1