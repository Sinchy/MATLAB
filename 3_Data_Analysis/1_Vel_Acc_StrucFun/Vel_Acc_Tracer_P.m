fileID = fopen('trks_dir2.txt');
CC = textscan(fileID,'%s','Delimiter','\n');
hubs=CC{1,1};
fclose(fileID);

addpath('./Post_analysis/')
% for i=1:size(hubs,1)
%     track_dir=[hubs{i,1} '/'];
% tracks = ReadAllTracks(track_dir);
% tracks = tracks(:,[3 4 5 2 1]);
% save([track_dir  '/allTracks.mat'], 'tracks', '-v7.3');
% clear tracks
% disp(['Conv to mat done: ' num2str(i)])
% end

%%
addpath('./Post_analysis/1-Basics/')
parfor i=1:size(hubs,1)
        track_dir=[hubs{i,1} '/'];
%         alltrk=load([track_dir '/allTracks.mat']);
        tracks = ReadAllTracks(track_dir);
        tracks = tracks(:,[3 4 5 2 1]);
% 
        filterwidth = 3;
        fitwidth = 9;
        framerate = 4000;
        vel_acc_data = ashwanth_rni_vel_acc(tracks, filterwidth, fitwidth, framerate);
%         clear tracks
        tracks=[];
        vel_acc_data = sortrows(vel_acc_data,4);

        vel_acc_data(:,12:14) = rem_mean(vel_acc_data, -40, 40, -40, 40, -30, 30, 10);
        
        % vel_acc_data: x,y,z,frame,trID,vx,vy,vz,ax,ay,az,vx',vy',vz'
% %         save([track_dir  '/allTracks_withVelAcc.mat'], 'vel_acc_data', '-v7.3');
%         av=matfile(sprintf([track_dir  '/allTracks_withVelAcc.mat']),'writable',true);
%         av.vel_acc_data=vel_acc_data;
% %         clear vel_acc_data
        save_all_tracks(track_dir,vel_acc_data);
        vel_acc_data=[];
        disp(['vel acc calc done: ' num2str(i)])
end