% This script extracts the sequences in the following way:

% 1. take all sequences in the path current-folder/camx
% 2. generate folder called like the sequence
% 3. extract the images into subfolders camx

%% detect sequences in the current path
clear all

listCam1 = dir('./CAM1');
listCam2 = dir('./CAM2');
listCam3 = dir('./CAM3');


for k = 1:length(listCam1)
    seqIdx1(k) = any(strfind(listCam1(k).name,'.seq'));
end

for k = 1:length(listCam2)
    seqIdx2(k) = any(strfind(listCam2(k).name,'.seq'));
end

for k = 1:length(listCam3)
    seqIdx3(k) = any(strfind(listCam3(k).name,'.seq'));
end

% check for identical sequence-names
foundSeq = [];
for k = find(seqIdx1)
    for kk = 1:length(listCam2)
        if strcmp(listCam1(k).name,listCam2(kk).name)
            for kkk = 1:length(listCam3)
                if strcmp(listCam1(k).name,listCam3(kkk).name)
                    fprintf(1,'sequence found: %s\n',listCam1(k).name);
                    foundSeq = [ foundSeq; k, kk, kkk];
                end
            end
        end
    end
end

%% cycle trough sequences and extract
for k = 1:size(foundSeq,1)
    % get name of the sequence
    [~, fname, ~] = fileparts(listCam1(foundSeq(k,1)).name);
    mkdir(fname)
    [~, imgCam] = Norpix2MATLAB(sprintf('./CAM1/%s',listCam1(foundSeq(k,1)).name) );
    mkdir([fname '/cam1']);
    for kk = 1:size(imgCam,3)
        I = uint8(imgCam(:,:,kk));
        imFileName = sprintf('%s/cam1/image_%05d.bmp',fname,kk);
        imwrite(I, imFileName);
        fprintf(1,'Writing image %s\n',imFileName);
    end
    clear imgCam;
    [~, imgCam] = Norpix2MATLAB(sprintf('./CAM2/%s',listCam2(foundSeq(k,2)).name) );
    mkdir([fname '/cam2']);
    for kk = 1:size(imgCam,3)
        I = uint8(imgCam(:,:,kk));
        imFileName = sprintf('%s/cam2/image_%05d.bmp',fname,kk);
        imwrite(I, imFileName);
        fprintf(1,'Writing image %s\n',imFileName);
    end
    clear imgCam;
    [~, imgCam] = Norpix2MATLAB(sprintf('./CAM3/%s',listCam3(foundSeq(k,3)).name) );
    mkdir([fname '/cam3']);
    for kk = 1:size(imgCam,3)
        I = uint8(imgCam(:,:,kk));
        imFileName = sprintf('%s/cam3/image_%05d.bmp',fname,kk);
        imwrite(I, imFileName);
        fprintf(1,'Writing image %s\n',imFileName);
    end
    
    % generate mp4-video
    command_cam1 = sprintf('ffmpeg -i %s/cam1/image_%%05d.bmp -c:v libx264 -an %s/cam1.mp4',fname, fname );
    command_cam2 = sprintf('ffmpeg -i %s/cam2/image_%%05d.bmp -c:v libx264 -an %s/cam2.mp4',fname, fname );
    command_cam3 = sprintf('ffmpeg -i %s/cam3/image_%%05d.bmp -c:v libx264 -an %s/cam3.mp4',fname, fname );
    system(command_cam1);
    system(command_cam2);
    system(command_cam3);
    
    % now create a multi-view video of this
    command_multi = sprintf('ffmpeg -i %s/cam1.mp4 -i %s/cam2.mp4 -i %s/cam3.mp4 -filter_complex "nullsrc=size=1280x960 [base]; [0:v] setpts=PTS-STARTPTS, scale=640x480 [upperright]; [1:v] setpts=PTS-STARTPTS, scale=640x480 [lowerleft]; [2:v] setpts=PTS-STARTPTS, scale=640x480 [lowerright]; [base][upperright] overlay=shortest=1:x=640 [tmp1]; [tmp1][lowerleft] overlay=shortest=1:x=0:y=480 [tmp2]; [tmp2][lowerright] overlay=shortest=1:x=640:y=480" -c:v libx264 -an %s/multi.mp4', fname, fname, fname, fname);

    
    
    
    
    clear imgCam;
end
