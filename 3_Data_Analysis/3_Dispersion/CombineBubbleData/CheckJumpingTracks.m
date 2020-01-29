function is_same = CheckJumpingTracks(tracks_jumping, load_file)
%% get the file path to the image
% April and Oct data sets
fileID = fopen('./Bubble_img_Dir.txt');
CC = textscan(fileID,'%s','Delimiter','\n');
hubs=CC{1,1};
fclose(fileID);

% August data sets
path_prefix = '/media/Share2/Projects/1-Bubble/CamConfig_of_07.13.18/Data/';
date = dir(path_prefix);
date = date([date(:).isdir]==1);
date = date(~ismember({date(:).name},{'.','..'}));
for i = 1 : size(date, 1)
    %for each date, go through every run
    run = dir([path_prefix date(i).name]);
    run = run([run(:).isdir]==1);
    run = run(~ismember({run(:).name},{'.','..'}));
    for j = 1 : size(run, 1)
        % for each run, go through all the partition
        part = dir([path_prefix date(i).name '/' run(j).name]);
        part = part([part(:).isdir]==1);
        part = part(~ismember({part(:).name},{'.','..'}));
        for k = 1 : size(part, 1)
            hubs = [hubs; [path_prefix date(i).name '/' run(j).name '/' part(k).name]];
        end
    end
end

%% check every tracks
trID = unique(tracks_jumping(:, 1));
num_track = size(trID, 1);
i = 1;
figure;
is_same = zeros(num_track, 1);
if load_file
    load is_same.mat
end
x = 0;
while (i <= num_track)
    track_to_examine = tracks_jumping(tracks_jumping(:, 1) == trID(i), :);
    data_set_ID = track_to_examine(1, 21);
    img_path = hubs(data_set_ID);
    % load calibration file
    if data_set_ID <= 23
        load VSC_Calib_10.22.17.mat
    elseif data_set_ID <= 70
        load VSC_Calib_04.04.18.mat
    else
        load VSC_Calib_07.16.18.mat
    end
    % calculate 2D centers
    track_2D = [];
    for j = 0 : 3
        track_2D(: , j * 2 + 1 : (j + 1) * 2) = calibProj_Tsai(camParaCalib(j + 1), track_to_examine(:,4:6));
    end
    
    % show the image frame by frame
    partition_no = img_path{1}(end);
    name_str = ['H001S000' num2str(partition_no)];
    start_frame = track_to_examine(1, 2);
    end_frame = track_to_examine(end, 2);
    if end_frame - start_frame > 20 && x < 3
        end_frame = start_frame + 20;
    end
    for f = start_frame : end_frame
        for j = 1 : 4
            if data_set_ID <= 23
                sub_folder_name = ['C00' num2str(j) name_str];
            else
                sub_folder_name = ['C00' num2str(j) '_' name_str];
            end
            img = imread([img_path{1} '/' sub_folder_name '/' sub_folder_name num2str(f, '%06.0f') '.tif']);
            subplot(2, 2, j);
            imshow(img);
            hold on
            plot(track_2D(: , (j - 1) * 2 + 1), track_2D(: , j * 2), 'b*');
            hold off
        end
        pause(0.00001);
    end
    x = input('Is it the same track? 0 - No, 1 - Yes, 2 - All wrong, 3 - replay \n');
    if x < 3
        is_same(i) = x;
        i = i + 1;
        save('is_same.mat', 'is_same', 'i');
    end
end

end

