function VelAccSF(project_path)
C_code_path = 'D:\0.Code\MATLAB\3_Data_Analysis\1_Vel_Acc_StrucFun\CVersion2\VelAcc\x64\Release\';
result_path = [project_path '\results\'];


if ~exist(result_path, 'dir')
    mkdir(result_path);
end
if ~exist([project_path '\results\filter_tracks.mat'], 'file')
    disp('Filtering tracks...');

    d = dir(project_path);
    dfolders = d([d(:).isdir]) ;
    dfolders = dfolders(~ismember({dfolders(:).name},{'.','..', 'results'}));

    for i = 1 : size(dfolders, 1)
        while (~exist([project_path '\' dfolders(i).name '\tracks.gdf'], 'file'))
            tic
                system([C_code_path 'VelAcc.exe ' project_path '\' dfolders(i).name '> ' project_path '\results\result.txt']);
            toc;
        end
    end
    delete([project_path '\results\result.txt']);

    %% 
    disp('Calculating velocity fluctuation...');
    tic
    addpath D:\0.Code\MATLAB\3_Data_Analysis\1_Vel_Acc_StrucFun;
    for i = 1 : size(dfolders, 1)
        subtracks = read_gdf([project_path '\' dfolders(i).name '\tracks.gdf'], 'double');
        delete([project_path '\' dfolders(i).name '\tracks.gdf']);
        if i == 1
            tracks = subtracks;
        else
            tracks = CombineTracks(tracks, subtracks);
        end
    end
    pos_max = ceil(max(tracks(:,1:3)));
    pos_min = floor(min(tracks(:, 1:3)));
    [vel_fluct, mean_info] = rem_mean(tracks, pos_min(1), pos_max(1), pos_min(2), pos_max(2),pos_min(3), pos_max(3), 10);
    tracks = [tracks vel_fluct];
    clear vel_fluct
    save([project_path '\results\filter_tracks.mat'], 'tracks', 'mean_info', '-v7.3');
    toc
else 
    load([project_path '\results\filter_tracks.mat']);
        pos_max = ceil(max(tracks(:,1:3)));
    pos_min = floor(min(tracks(:, 1:3)));
end


%%
disp('Calculating structure function...');
tic
tracks = sortrows(tracks, 4); % sort tracks according to frames
[frame_no, start_index, ic] = unique(tracks(:,4),'first');
a_counts = accumarray(ic,1);
frame_info = [frame_no, start_index, a_counts];
num_frame = 2000; % number of frames to calculate SF
frame_select = frame_no(randperm(numel(frame_no), num_frame)); % randomly select frames
% prepare frames for calculating SF
num_total_particles = sum(frame_info(ismember(frame_info(:,1), frame_select), 3));
tracks_SF = zeros(num_total_particles, 7);
index = 1;
for i = 1 : num_frame
    frame1_info = frame_info(frame_info(:, 1) == frame_select(i), :);
    frame1 = tracks(frame1_info(2) : frame1_info(2) + frame1_info(3) - 1, [1:3 4 12:14]);
    tracks_SF(index : index + frame1_info(3) - 1, :) = frame1;
    index = index + frame1_info(3);
end
clear tracks; % release the memory

tracks_SF = sortrows(tracks_SF, 4); 
if exist([result_path 'filter_data_bin.mat'], 'file')
    delete([result_path 'filter_data_bin.mat']);
end
% using map to get the data in order to save memory
    fileID = fopen([result_path 'filter_data_bin.mat'], 'w');
    fwrite(fileID, tracks_SF, 'double'); % save the data
    fclose(fileID); 
    [row, col] = size(tracks_SF);
    % map a variable is to save memory and enable to get more workers for
    % parallelization
     data_map = memmapfile([result_path 'filter_data_bin.mat'], 'Format',{'double',[row col],'tracks'}); 
     clear tracks_SF;
     
max_pos = max(pos_max) - min(pos_min);
redges_log = 10.^(-2:0.1:ceil(log10(max_pos))); 
statistics_struct = CalSF(data_map,redges_log);
save([project_path '\results\SF.mat'], 'statistics_struct','redges_log', '-v7.3');
clear data_map;
delete([result_path 'filter_data_bin.mat']);
toc


end

