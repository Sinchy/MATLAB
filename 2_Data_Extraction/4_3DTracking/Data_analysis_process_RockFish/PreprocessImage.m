function PreprocessImage(dirr, calibration_name, remove_bubble, skip_frame, save_dir, totalImgs)
% dirr = [dirr '/'];
dir_process = extractBefore(dirr, 'VONSET');
dir_process = [dir_process, 'VONSET/ProcessedData'];
if ~exist(dir_process, 'dir')
    mkdir(dir_process);
end
dir_left = extractAfter(dirr, 'Data');
is_windows = ~contains(dirr, '/');
if is_windows
    folders = strsplit(dir_left, '\');
    for i = 2 : size(folders, 2)
        dir_process = [dir_process, '\' folders{i}];
        if ~exist(dir_process, 'dir')
            mkdir(dir_process);
        end
    end
else
    folders = strsplit(dir_left, '/');
    for i = 1 : size(folders, 2)
        dir_process = [dir_process, '/' folders{i}];
        if ~exist(dir_process, 'dir')
            mkdir(dir_process);
        end
    end
end
dir_process = [dir_process, '/'];
dirr = [dirr, '/'];
if ~exist('calibration_name', 'var')
    calibration_name= 'camParaCalib';
end

if ~exist('skip_frame', 'var')
    skip_frame= 1;
end

if ~exist('save_dir', 'var')
    save_dir = dir_process;
end

if ~exist('remove_bubble', 'var')
    remove_bubble = 0;
end

if ~exist('totalImgs', 'var')
    a = dir([dirr  'Cam1/*.tif']);
    totalImgs = numel(a); 
end
totalImgs = totalImgs - 2;
%% Inputs
camsave_dir = {[save_dir 'cam_1/'],[save_dir 'cam_2/'],[save_dir 'cam_3/'],[save_dir 'cam_4/'], [save_dir 'cam_5/'],[save_dir 'cam_6/'] }';
ncams = 3;
for i = 1 : ncams
    if ~exist(camsave_dir{i}, 'dir')
        mkdir(camsave_dir{i});
    end
end
print_dir = {['cam_1/'],['cam_2/'],['cam_3/'],['cam_4/'],['cam_5/'],['cam_6/'] }';

log_filepath = [dir_process 'Log.txt'];
start = 1;
if exist(log_filepath, 'file')
if contains(fileread(log_filepath), 'cam1 has been processed!')
    if contains(fileread(log_filepath), 'cam2 has been processed!')
        if contains(fileread(log_filepath), 'cam3 has been processed!')
            start = 4;
        else
            start = 3;
        end
    else
        start = 2;
    end
end
end
%% Getting the background
totalImgs_for_background = 2000;
if totalImgs_for_background > totalImgs
    totalImgs_for_background = totalImgs;
end
imgdir = [ dirr 'Cam1/cam1frame000001.tif'];
img = imread(imgdir);
[Npixh, Npixw] = size(img);
% ncams = 4;
% Npixh = 1024;
% Npixw = 1024;
bak = zeros(Npixh,Npixw,ncams);
%% Background images (using normal images)
% in the form of bak(:,:,cam)

for cam = start : ncams
    num = 0;
    camdir = [dirr 'Cam' num2str(cam) '/'];
    for I = 1:totalImgs_for_background
        if (mod(I,20) == 1)
            imgdir = [camdir 'cam' num2str(cam) 'frame' num2str(I,'%06.0f') '.tif'];
            img = imread(imgdir);
            if isa(img, 'uint16')
                img = Convert16bitTo8bit(img);
            end
            bak(:,:,cam) = bak(:,:,cam) + double(img);
            num = num + 1;
        end
    end
    bak(:,:,cam) = bak(:,:,cam)/num;
    bak1 = uint8(bak(:,:,cam));
    bak(:,:,cam) = bak1;
end
bak = uint8(bak);

% figure;
% for i = 1 : 4
%     subplot(2,2,i);
%     imshow(bak(:, :, i));
% end

save([save_dir 'background.mat'],'bak')

%% processing
% correction = [1 1 0 0 0 0];

threshold = [0.5; 0.5; 0.5; 0.5; 0.5; 0.5];
   pp = parpool;
for cam = start:ncams
    camdir = [dirr 'Cam' num2str(cam) ];
    % adjust threshold
    low = 0;
    high = 1;
    h_end = 3;
%     removed = 0;
    imgdir = [camdir '/cam' num2str(cam) 'frame000001.tif'];
    img = imread(imgdir);
    if isa(img, 'uint16')
            img = Convert16bitTo8bit(img);
    end
    img1 = double(bak(:,:,cam)) - double(img);
    img3 = uint8(img1); 
        % remove bubble
    if remove_bubble %&& ~removed
        img3 = RemoveBubble(img3, 2, 0);
%         removed = 1;
    end
    while h_end > 2 || h_end == 0 
        img4 = imadjust(img3,[0 threshold(cam)]);
        img4 = LaVision_ImgProcessing(img4);
        [h,~] = imhist(img4);
        h_end = h(end);
         if h_end > 1
            low = threshold(cam);
            threshold(cam) = (threshold(cam) + high) / 2;
        elseif h_end == 0
            high = threshold(cam);
            threshold(cam) = (threshold(cam) + low) / 2;
        end
    end
    
 
    parfor I = 1:floor(totalImgs/skip_frame)
        imgdir = [camdir '/cam' num2str(cam) 'frame' num2str(I * skip_frame,'%06.0f') '.tif'];
%         imgdir = [camdir 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') 'raw.tif'];
        img = imread(imgdir);
        if isa(img, 'uint16')
                img = Convert16bitTo8bit(img);
        end
%         img1 = -double(bak(:,:,cam)) + double(img);
        img1 = double(bak(:,:,cam)) - double(img);
%         img2=img1./max(max(img1)).*255;
        img3 = uint8(img1);
        img4 = imadjust(img3,[0 threshold(cam)]);
        img4 = LaVision_ImgProcessing(img4);
        % remove bubble
        if remove_bubble 
            img4 = RemoveBubble(img4, 1, 1);
        end
        if ~exist(camsave_dir{cam}, 'dir')
            mkdir(camsave_dir{cam});
        end
        imwrite(img4,[camsave_dir{cam} 'cam' num2str(cam) 'frame' num2str(I ,'%06.0f') '.tif']);           
    end
    disp(['cam' num2str(cam) ' has been preprossed.'])
    % make image sequence txt files
    fID = fopen([save_dir 'cam' num2str(cam) 'ImageNames.txt'],'w');
    a = dir(camdir);
    frame = 1;
    for i = 1:size(a,1)
        if (a(i).isdir == 0)
%           fprintf(fID, ['C00' num2str(cam) 'H001S0001/' '%s\n'], a(i).name);
            fprintf(fID, [print_dir{cam} 'cam' num2str(cam) 'frame' num2str(frame,'%06.0f') '.tif\n']);
            frame = frame + 1;
        end
    end
    fclose(fID);
        file_ID = fopen(log_filepath, 'a');
    fprintf(file_ID, ['cam' num2str(cam) ' has been processed!\n']);
end
delete(pp);
% generate configuration files
GenerateConfigFileV2(dir_process, 1, totalImgs/skip_frame, ncams, calibration_name);
copyfile([dirr  'S01/' calibration_name '.txt'], [dir_process  dfolders(i).name]);
end

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
end

function Im8_woOffSet  = Convert16bitTo8bit(Im16)
dbIm16 = double(Im16)+1;
db16min = min(dbIm16(:)); db16max = max(dbIm16(:));
TgBit = 8; % or any other lower bit scale
% example with 16bit to 8bit
%Norm_wOffSet = dbIm16/db16max; % maintaining putative offset from 0 in the data
%Im8_wOffSet = uint8(Norm_wOffSet*2^TgBit-1); % back to 0:2^8-1
Norm_woOffSet = (dbIm16-db16min)/(db16max-db16min); % Scales linearly to full range
Im8_woOffSet = uint8(Norm_woOffSet*2^TgBit-1); % back to 0:2^8-1
end

function img = RemoveBubble(img, radius_factor, circle_test)
            % get bubble location and size
            img0 = img >= 30; % change it to binary image
            stats = regionprops('table',img0,'Centroid',...
            'MajorAxisLength','MinorAxisLength', 'Circularity');
            centers = stats.Centroid;
            diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
            radii = diameters/2;
%             circularity = stats.Circularity;
            ratio = stats.MajorAxisLength ./ stats.MinorAxisLength;
            if circle_test
                bubble_label = (radii >= 3 & ratio < 1.1) | (radii > 5); 
            else
                bubble_label = radii >= 3;
            end
            pos2D = centers(bubble_label == 1, :);
            radii_bubble = radii(bubble_label == 1);
            % make bubble image
            mask = createCirclesMask(size(img), pos2D, radii_bubble * radius_factor);
            img(mask) = 0;
end

function mask = createCirclesMask(varargin)
%xDim,yDim,centers,radii)
% Create a binary mask from circle centers and radii
%
% SYNTAX:
% mask = createCirclesMask([xDim,yDim],centers,radii);
% OR
% mask = createCirclesMask(I,centers,radii);
%
% INPUTS: 
% [XDIM, YDIM]   A 1x2 vector indicating the size of the desired
%                mask, as returned by [xDim,yDim,~] = size(img);
%  
% I              As an alternate to specifying the size of the mask 
%                (as above), you may specify an input image, I,  from which
%                size metrics are to be determined.
% 
% CENTERS        An m x 2 vector of [x, y] coordinates of circle centers
%
% RADII          An m x 1 vector of circle radii
%
% OUTPUTS:
% MASK           A logical mask of size [xDim,yDim], true where the circles
%                are indicated, false elsewhere.
%
%%% EXAMPLE 1:
%   img = imread('coins.png');
%   [centers,radii] = imfindcircles(img,[20 30],...
%      'Sensitivity',0.8500,...
%      'EdgeThreshold',0.30,...
%      'Method','PhaseCode',...
%      'ObjectPolarity','Bright');
%   figure
%   subplot(1,2,1);
%   imshow(img)
%   mask = createCirclesMask(img,centers,radii);
%   subplot(1,2,2);
%   imshow(mask)
%
%%% EXAMPLE 2:
%   % Note: Mask creation is the same as in Example 1, but the image is
%   % passed in, rather than the size of the image.
%
%   img = imread('coins.png');
%   [centers,radii] = imfindcircles(img,[20 30],...
%      'Sensitivity',0.8500,...
%      'EdgeThreshold',0.30,...
%      'Method','PhaseCode',...
%      'ObjectPolarity','Bright');
%   mask = createCirclesMask(size(img),centers,radii);
%
% See Also: imfindcircles, viscircles, CircleFinder
%
% Brett Shoelson, PhD
% 9/22/2014
% Comments, suggestions welcome: brett.shoelson@mathworks.com
% Copyright 2014 The MathWorks, Inc.
narginchk(3,3)
if numel(varargin{1}) == 2
	% SIZE specified
	xDim = varargin{1}(1);
	yDim = varargin{1}(2);
else
	% IMAGE specified
	[xDim,yDim] = size(varargin{1});
end
centers = varargin{2};
radii = varargin{3};
xc = centers(:,1);
yc = centers(:,2);
[xx,yy] = meshgrid(1:yDim,1:xDim);
mask = false(xDim,yDim);
for ii = 1:numel(radii)
	mask = mask | hypot(xx - xc(ii), yy - yc(ii)) <= radii(ii);
end
end
