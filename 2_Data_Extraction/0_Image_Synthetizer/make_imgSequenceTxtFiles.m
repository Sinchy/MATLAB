savedir = '/home/tanshiyong/Documents/Data/Mass-Transfer/2018-11-03/ForVSC_100fps/';
% savedir = '/home/shiyongtan/Documents/Experiment/EXPVSC/VSC072018/';
cam_dir = {[savedir 'cam1/'],[savedir 'cam2/'],[savedir 'cam3/'],[savedir 'cam4/'],[savedir 'cam5/'],[savedir 'cam6/'] }';
addpath(savedir);
print_dir = {['cam1/'],['cam2/'],['cam3/'],['cam4/'],['cam5/'],['cam6/'] }';

first_frame = 1;
ncams = 6;
for cam = 3:4
    fID = fopen([savedir 'cam' num2str(cam) 'ImageNames.txt'],'w');
    camdir = [cam_dir{cam}];
    a = dir(camdir);
    frame = first_frame;
    for i = 1:size(a,1)
        if (a(i).isdir == 0)
%           fprintf(fID, ['C00' num2str(cam) 'H001S0001/' '%s\n'], a(i).name);
            fprintf(fID, [print_dir{cam} 'cam' num2str(cam) 'frame' num2str(frame) '.tiff\n']);
% fprintf(fID, [print_dir{cam} 'cam' num2str(cam) 'frame' num2str(frame) '.tif\n']);
%             fprintf(fID, [print_dir{cam} 'cam' num2str(frame,'%04.0f') '.tif\n']);
%           fprintf(fID, '%s\n', a(i).name);
            frame = frame + 1;
        end
    end
    fclose(fID);
end
