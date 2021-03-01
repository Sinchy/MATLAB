%% Inputs
% dirr = 'C:\Users\aks5577\Desktop\cam_config_of_04.04.18\ProcessedImages\04.12.18\Bubbles3\noBubbles_200fr\';
% cam_dir = {[dirr 'cam1_corrected/'],[dirr 'cam2_corrected/'],[dirr 'cam3/'],[dirr 'cam4/'] }';
% save_dir = 'C:\Users\aks5577\Desktop\cam_config_of_04.04.18\ProcessedImages\04.12.18\Bubbles3\noBubbles_200frLavImgProcess\';
% camsave_dir = {[save_dir 'cam1_corrected/'],[save_dir 'cam2_corrected/'],[save_dir 'cam3/'],[save_dir 'cam4/'] }';
% totalImgs = 200;
% ncams = 4;

%% Background image
function outImg = LaVision_ImgProcessing(a)
%     for cam = 1:4
%         for I = 1:200
%             a = [cam_dir{cam} 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') '.tif'];
%             a = double(imread(a));
            % subtrack sliding minimum
            a = double(a);
            b = imerode(a, true(3));
            c = a - b;
            b = imerode(a, true(3));
            c = c - b;

            % Gaussian smoothing filter
            d = imgaussfilt(c);

            % image normalization
            filt_size = 100;
            filt = 1/filt_size^2 .*true(filt_size);
            e = imfilter(d,filt);

            f = a - e;

            % sharpen the image
            outImg = uint8(imsharpen(f));

%             imwrite(uint8(g),[camsave_dir{cam} 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') '.tif']);
%         end
%     end
%%
% figure;imshow(uint8(a));
% figure;imshow(uint8(c));
% figure;imshow(uint8(d));
% figure;imshow(uint8(e));
% figure;imshow(uint8(f));
% figure;imshow(uint8(g));
% 
% res = a - g;
% figure;imshow(uint8(res));

