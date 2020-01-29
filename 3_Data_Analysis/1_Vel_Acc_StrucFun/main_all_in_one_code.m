%% Converting all the tracks from .txt to .mat format

% directory_of_all_tracks = 'T:\Projects\1-Bubble\CamConfig_of_07.13.18\Processed_tracks\';
% folder_level_1 = dir(directory_of_all_tracks);
% folder_level_1(1:2,:) = [];

% for i = 1:size(folder_level_1,1)
%     folder_level_2 = dir([folder_level_1(i).folder '/' folder_level_1(i).name '/']);
%     folder_level_2(1:2,:) = [];
%     
%     for j = 1:size(folder_level_2,1)
%         if (strcmp(folder_level_2(j).name, 'ForVSC'))
%             continue;
%         end
%         
%         track_dir = [folder_level_2(j).folder '/' folder_level_2(j).name '/Tracks/ConvergedTracks/'];
%         tracks = ReadAllTracks(track_dir);
%         tracks = tracks(:,[3 4 5 2 1]);
%         save([folder_level_2(j).folder '/' folder_level_2(j).name  '/allTracks.mat'], 'tracks', '-v7.3');
%         clear tracks       
%     end
% end

%% Getting the velocity and acceleration data

% directory_of_all_tracks = 'T:\Projects\1-Bubble\CamConfig_of_07.13.18\Processed_tracks\';
% folder_level_1 = dir(directory_of_all_tracks);
% folder_level_1(1:2,:) = [];

% addpath('./1-Basics');
% for i = 1:size(folder_level_1,1)
%     folder_level_2 = dir([folder_level_1(i).folder '/' folder_level_1(i).name '/']);
%     folder_level_2(1:2,:) = [];
%     
%     for j = 1:size(folder_level_2,1)
% %         load([folder_level_2(j).folder '/' folder_level_2(j).name '/allTracks.mat']);
% 
%         filterwidth = 3;
%         fitwidth = 9;
%         framerate = 5000;
%         vel_acc_data = ashwanth_rni_vel_acc(tracks, filterwidth, fitwidth, framerate);
%         clear tracks
%         vel_acc_data = sortrows(vel_acc_data,4);
% 
%         vel_acc_data(:,12:14) = rem_mean(vel_acc_data, -40, 40, -40, 40, -30, 30, 10);
%         
%         % vel_acc_data: x,y,z,frame,trID,vx,vy,vz,ax,ay,az,vx',vy',vz'
%         save([folder_level_2(j).folder '/' folder_level_2(j).name  '/allTracks_withVelAcc.mat'], 'vel_acc_data', '-v7.3');
%         
%         clear vel_acc_data
% 
%     end
% end

%% Separating each track dataset into 3 parts for submitting multiple jobs on marcc

directory_of_all_tracks = 'T:\Projects\1-Bubble\CamConfig_of_07.13.18\Processed_tracks\';
folder_level_1 = dir(directory_of_all_tracks);
folder_level_1(1:2,:) = [];

for i = 1:size(folder_level_1,1)
    folder_level_2 = dir([folder_level_1(i).folder '/' folder_level_1(i).name '/']);
    folder_level_2(1:2,:) = [];
    
    for j = 1:size(folder_level_2,1)
        if (strcmp(folder_level_2(j).name, 'ForVSC') || (i==1 && j==1))
            continue;
        end
        
        load([folder_level_2(j).folder '/' folder_level_2(j).name '/allTracks.mat']);
        
        [c,ia,ic]=unique(tracks(:,5));
        c1 = floor(numel(c)/3);
        I1 = max(find(tracks(:,5) == c1));
        tmp = tracks(1:I1,:);
        save([folder_level_2(j).folder '/' folder_level_2(j).name  '/Tracks1_' folder_level_1(i).name '_'...
            folder_level_2(j).name '.mat'], 'tmp', '-v7.3');
        
        c2 = floor(2*numel(c)/3);
        I2 = max(find(tracks(:,5) == c2));
        tmp = tracks(I1+1:I2,:);
        save([folder_level_2(j).folder '/' folder_level_2(j).name  '/Tracks2_' folder_level_1(i).name '_'...
            folder_level_2(j).name '.mat'], 'tmp', '-v7.3');
 
        tmp = tracks(I2+1:end,:);
        save([folder_level_2(j).folder '/' folder_level_2(j).name  '/Tracks3_' folder_level_1(i).name '_'...
            folder_level_2(j).name '.mat'], 'tmp', '-v7.3');
 
        clear tracks
    end
end



