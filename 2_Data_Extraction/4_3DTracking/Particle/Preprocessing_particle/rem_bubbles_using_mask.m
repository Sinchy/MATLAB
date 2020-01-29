%% Inputs
mask_dir = '/home/shiyongtan/Documents/Experiment/EXP13/Bubbles_mask/';
dirr = '/home/shiyongtan/Documents/Experiment/EXP13/withBubbles/';
cam_dir = {[dirr 'cam1_corrected/'],[dirr 'cam2_corrected/'],[dirr 'cam3/'],[dirr 'cam4/'] }';
save_dirr = '/home/shiyongtan/Documents/Experiment/EXP13/noBubbles/';
camsave_dir = {[save_dirr 'cam1_corrected/'],[save_dirr 'cam2_corrected/'],[save_dirr 'cam3/'],[save_dirr 'cam4/'] }';
ncams = 4;


%% processing
for cam = 1:4
    load([mask_dir 'Cam' num2str(cam) '.mat']);
    for I = 4000:5000
        imgdir = [cam_dir{cam} 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') '.tif'];
%         imgdir = [camdir 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') 'raw.tif'];
        img = imread(imgdir);
        % getting the mask
        eval(['mask = Image' num2str(I,'%06.0f') ';']);
        % modifying the mask to remove extra residual around the bubble
        mask1 = mask;
        [row, col] = find(mask == 1);
        rows = zeros(size(row,1),20); cols = zeros(size(col,1),20); % extending the radius of bubbles by 10 px
        for i = 1:10
            rows(:,i+10) = min(row + i,1024);
            rows(:,i) = max(1,row - i);
        end
        for i = 1:10
            cols(:,i+10) = min(1024,col + i);
            cols(:,i) = max(1,col - i);
        end
        linearInd = sub2ind(size(mask1),rows,cols);
        mask1(linearInd) = 1;
        img2 = uint8(double(img).*(~mask1));
        imwrite(img2,[camsave_dir{cam} 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') '.tif']);
        if (mod(I,50) == 0)
            I
        end
    end
    
end
