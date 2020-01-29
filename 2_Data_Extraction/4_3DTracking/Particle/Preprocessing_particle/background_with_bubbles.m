%% Inputs
% dirr = '/home/shiyongtan/Documents/Experiment/EXP24/Raw_image/';
% savedir = '/home/shiyongtan/Documents/Experiment/EXP24/Raw_image/';
% dirr = '/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072718/';
% savedir = '/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072718/';
dirr ='Z:\Projects\1-Bubble\CamConfig_of_07.13.18\Data\07.27.18\Run2_Bubbles\Bubbles1/';
savedir ='G:\My Drive\PHD\2018-Fall\multi_phase/';
totalImgs = 1000;
ncams = 4;
Npixh = 1024;
Npixw = 1024;
bak = zeros(Npixh,Npixw,ncams);
%% Background images (using normal images)
% in the form of bak(:,:,cam)

for cam = 1:ncams
    num = 0;
    camdir = [dirr 'C00' num2str(cam) '_H001S0001/'];
    for I = 1:totalImgs
        if (mod(I,20) == 0)
            imgdir = [camdir 'C00' num2str(cam) '_H001S00010' num2str(I,'%05.0f') '.tif'];
            img = imread(imgdir);
            bak(:,:,cam) = bak(:,:,cam) + double(img);
            num = num + 1;
        end
    end
    bak(:,:,cam) = bak(:,:,cam)/num;
    bak1 = uint8(bak(:,:,cam));
    bak(:,:,cam) = bak1;
end
bak = uint8(bak);

figure;
for i = 1 : 4
    subplot(2,2,i);
    imshow(bak(:, :, i));
end

save([savedir 'background.mat'],'bak')
%% using bakground image
% dir = 'S:/Projects/Bubble/7.26.17/Background/';
% for 