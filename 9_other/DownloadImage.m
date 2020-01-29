datapath_prefix = '/media/Share2/Projects/1-Bubble/CamConfig_of_07.13.18/Data';
save_path_prefix = '/media/FileStorage/Data/Bubbles/';

% parfor i = 1 : length(downloadlist)
%     datapath = [datapath_prefix, strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/'), '/'];
%     first_dir = extractBefore(extractAfter(datapath, 'Data/'), '/'); %date
%     mkdir([save_path_prefix first_dir]);
%     second_dir = extractBefore(extractAfter(datapath, [ first_dir '/']), '/'); % which run
%     mkdir([save_path_prefix first_dir '/' second_dir]);
%     third_dir = extractBefore(extractAfter(datapath, [ second_dir '/']), '/'); % which section
%     mkdir([save_path_prefix first_dir '/' second_dir '/' third_dir]);
%     section_no = extractAfter(third_dir, 'Bubbles');
%     for j = 1 : 6
%         mkdir([save_path_prefix first_dir '/' second_dir '/' third_dir '/Cam' num2str(j)]);
%         start_frame = max( str2num(downloadlist(i, 2)) - 100, 1);
%         end_frame = min(str2num(downloadlist(i, 4)) + 100, 7279);
%         image_prefix = ['C00' num2str(j) '_H001S000' section_no];
%         for l = start_frame : end_frame
%             copyfile([datapath image_prefix '/' image_prefix num2str(l, '%06.0f') '.tif'], ...
%                 [save_path_prefix first_dir '/' second_dir '/' third_dir '/Cam' num2str(j) '/cam' num2str(j) 'frame' num2str(l, '%05.0f') '.tif']);
%         end
%     end
% end % for apirl and Nov data, we also download reconstruction data 

%% copy mask
maskpath_prefix = '/media/Share2/Projects/1-Bubble/CamConfig_of_07.13.18/Processed_Images';
for i = 1 : length(downloadlist)
    maskpath = [maskpath_prefix strrep(convertStringsToChars(downloadlist(i, 1)), '\', '/')];
    first_dir = extractBefore(extractAfter(maskpath, 'Processed_Images/'), '/'); %date
%     mkdir([save_path_prefix first_dir]);
    second_dir = extractBefore(extractAfter(maskpath, [ first_dir '/']), '/'); % which run
%     mkdir([save_path_prefix first_dir '/' second_dir]);
    third_dir = extractBefore(extractAfter(maskpath, [ second_dir '/']), '/'); % which section
%     mkdir([save_path_prefix first_dir '/' second_dir '/' third_dir]);
%     section_no = extractAfter(third_dir, 'Bubbles');
    save_maskpath = [save_path_prefix first_dir '/' second_dir '/' third_dir '/mask'];
    mkdir(save_maskpath);
    i
     copyfile([maskpath '*'], save_maskpath, 'f');
end