datapath_prefix = '/media/Share2/Projects/1-Bubble/CamConfig_of_07.13.18/Data';
save_path_prefix = '/media/FileStorage/Data/Bubbles/';

maskpath_prefix = '/media/Share1/Projects/Bubble/Cam_Config_of_04.04.18/Processed_Images';
reconstruction_prefix = '/media/Share2/Share1/Projects/Bubble/Cam_Config_of_04.04.18/Reconstruction';
trackpath_prefix = '/media/Share1/Projects/Bubble/Cam_Config_of_04.04.18/ProcessedTracks';

% parfor i = 1 : length(downloadlist)
%     datapath = [datapath_prefix, strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/'), '/'];
%     first_dir = extractBefore(extractAfter(datapath, 'Data/'), '/'); %date
%     mkdir([save_path_prefix first_dir]);
%     second_dir = extractBefore(extractAfter(datapath, [ first_dir '/']), '/'); % which run
%     mkdir([save_path_prefix first_dir '/' second_dir]);
%     third_dir = extractBefore(extractAfter(datapath, [ second_dir '/']), '/'); % which section
%     mkdir([save_path_prefix first_dir '/' second_dir '/' third_dir]);
%     section_no = extractAfter(third_dir, 'Bubbles');
% %     % save mask
% %     save_maskpath = [save_path_prefix first_dir '/' second_dir '/' third_dir '/mask'];
% %     mkdir(save_maskpath);
% %     maskpath = [maskpath_prefix strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/') '/'];
% %     copyfile([maskpath '*'], save_maskpath, 'f');
%     % save tracks
%     save_trackpath = [save_path_prefix first_dir '/' second_dir '/' third_dir '/Tracks'];
%     mkdir(save_trackpath);
%     trackpath = [trackpath_prefix strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/') '/'];
%     copyfile([trackpath 'Tracks/*'], save_trackpath, 'f');
%     copyfile([trackpath 'result*'], save_trackpath, 'f');
%     % save bubble reconstruction
%     reconstruction_path = [reconstruction_prefix strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/'), '/'];
%     save_reconstruction_path = [save_path_prefix first_dir '/' second_dir '/' third_dir '/reconstruction'];
%     mkdir(save_reconstruction_path);
%     start_frame = max( str2num(downloadlist(i, 2)) - 100, 1);
%     end_frame = min(str2num(downloadlist(i, 4)) + 100, 7279);
%     for l = start_frame : end_frame 
%         copyfile([reconstruction_path 'Bubble_Frame_' num2str(l,'%06.0f') '.mat'], ...
%             [save_reconstruction_path '/']);
%     end
%     % image
%     for j = 1 : 6
%         mkdir([save_path_prefix first_dir '/' second_dir '/' third_dir '/Cam' num2str(j)]);
%         image_prefix = ['C00' num2str(j) '_H001S000' section_no];
%         for l = start_frame : end_frame
%             copyfile([datapath image_prefix '/' image_prefix num2str(l, '%06.0f') '.tif'], ...
%                 [save_path_prefix first_dir '/' second_dir '/' third_dir '/Cam' num2str(j) '/cam' num2str(j) 'frame' num2str(l, '%05.0f') '.tif']);
%         end
%     end
% end

%% copy mask and tracks
for i = 1 : length(downloadlist)
    maskpath = [maskpath_prefix strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/') '/'];
    first_dir = extractBefore(extractAfter(maskpath, 'Processed_Images/'), '/'); %date
    mkdir([save_path_prefix first_dir]);
    second_dir = extractBefore(extractAfter(maskpath, [ first_dir '/']), '/'); % which run
    mkdir([save_path_prefix first_dir '/' second_dir]);
    third_dir = extractBefore(extractAfter(maskpath, [ second_dir '/']), '/'); % which section
    mkdir([save_path_prefix first_dir '/' second_dir '/' third_dir]);
%     section_no = extractAfter(third_dir, 'Bubbles');
    save_maskpath = [save_path_prefix first_dir '/' second_dir '/' third_dir '/mask'];
    if ~exist(save_maskpath, 'dir')
        mkdir(save_maskpath);
         copyfile([maskpath '*'], save_maskpath, 'f');
    end
     
         % save tracks
    save_trackpath = [save_path_prefix first_dir '/' second_dir '/' third_dir '/Tracks'];
    if ~exist(save_trackpath, 'dir')
        mkdir(save_trackpath);
        trackpath = [trackpath_prefix strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/') '/'];
        copyfile([trackpath 'Tracks/*'], save_trackpath, 'f');
        copyfile([trackpath 'result*'], save_trackpath, 'f');
    end
end
