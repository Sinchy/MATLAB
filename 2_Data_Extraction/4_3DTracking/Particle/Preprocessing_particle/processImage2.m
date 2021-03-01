%% Inputs
dirr = '/home-4/stan26@jhu.edu/scratch/07.26.18/Run2_11_of_88_3s_Jet1/';
save_dir = '/home-4/stan26@jhu.edu/scratch/07.26.18/Run2_11_of_88_3s_Jet1/';
% dirr = '/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072618/';
% save_dir = '/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072618/';
% dirr ='/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072718/Raw_image/';
% save_dir ='/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072718/';
camsave_dir = {[save_dir 'cam1/'],[save_dir 'cam2/'],[save_dir 'cam3/'],[save_dir 'cam4/'], [save_dir 'cam5/'],[save_dir 'cam6/'] }';
totalImgs = 21841;
ncams = 4;

%% Background images
% in the form of bak(:,:,cam) 
correction = [1 1 0 0 0 0];
threshold = [0.45; 0.45; 0.45; 0.45; 0.18; 0.21];
%% processing
for cam = 1:4
    camdir = [dirr 'C00' num2str(cam) '_H001S0001/'];
    for I = totalImgs:-1:1
        imgdir = [camdir 'C00' num2str(cam) '_H001S00010' num2str(I,'%05.0f') '.tif'];
%         imgdir = [camdir 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') 'raw.tif'];
        img = imread(imgdir);
%         img1 = -double(bak(:,:,cam)) + double(img);
        img1 = double(bak(:,:,cam)) - double(img);
%         img2=img1./max(max(img1)).*255;
        img3 = uint8(img1);
        img4 = imadjust(img3,[0 threshold(cam)]);
        img4 = LaVision_ImgProcessing(img4);
        if (cam == 1 || cam == 2)
            imwrite(img4,[camsave_dir{cam} 'cam' num2str(cam) 'frame' num2str(I - 1 ,'%05.0f') '.tif']);
        else
            imwrite(img4,[camsave_dir{cam} 'cam' num2str(cam) 'frame' num2str(I ,'%05.0f') '.tif']);            
        end
            [h,f] = imhist(img4);
        if (mod(I,50) == 0)
            I
        end
    end
    
end
