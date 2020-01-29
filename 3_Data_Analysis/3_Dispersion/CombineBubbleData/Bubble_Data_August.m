% addpath('./Post_analysis')

% April and Oct data sets
fileID = fopen('./Bubble_Dir.txt');
CC = textscan(fileID,'%s','Delimiter','\n');
hubs=CC{1,1};
fclose(fileID);

% August data sets
path_prefix = '/media/Share2/Projects/1-Bubble/CamConfig_of_07.13.18/Reconstruction/';
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
hubs_2do=1:193;
Bdata_all = zeros(1,11);
tracks_all = zeros(1,21);
trID = 0;
for z=1:length(hubs_2do)
    z
    hub=hubs_2do(z);
    data_location=[hubs{hub,1}];
%     
%     if (hub < 71)
        data_location=[hubs{hub,1} '/'];
        t=load([data_location 'tracks.mat']);
%     else
%         t=load(data_location);
%     end
%     t=load([data_location '/tracks.mat']);
    tracks=t.tracks;
    t=[];
    minRadius = 0.2;
    maxRadius = 5;
    maxRadius_minTrkLen = 5;
%     if (hub < 24)
%         ind=tracks(:,7)>=minRadius & tracks(:,7)<=maxRadius;
%     else
        ind=tracks(:,7)>=minRadius & tracks(:,7)<=maxRadius & tracks(:,12)>0;
%     end
    tracks=tracks(ind,:);

    min_trk_l=50;

    % applying the minimum track length filter only on small bubbles
    tracks_smallBubbles = tracks(tracks(:,7) < maxRadius_minTrkLen,:);
    [C,ia,ib] = unique(tracks_smallBubbles(:,1));
%     for i=1:length(trkid)
%         trkidl(i)=sum(tracks_smallBubbles(:,1)==trkid(i));
%     end
    if size(ia,1) > 1
        trklen = ia(2:end) - ia(1:end-1);
        trklen(end+1) = size(tracks_smallBubbles,1) - ia(end) + 1;
    elseif size(ia,1) == 1
        trklen = size(tracks_smallBubbles,1) - ia + 1;
    else
        trklen = 0;
    end

    ind=ismember(tracks_smallBubbles(:,1),C(trklen > min_trk_l));
    tracks_smallBubbles=tracks_smallBubbles(ind,:);
    
    tracks(tracks(:,7) < maxRadius_minTrkLen,:) = [];
    tracks = [tracks_smallBubbles; tracks];
    trkid=unique(tracks(:,1));
    %% remove duplicate tracks

    % [trkidl,sort_ind]=sort(trkidl,'descend');
    % trkid=trkid(sort_ind);
    % repeated_trk=false(length(trkid),1);
    % for i=1:length(trkid)-1
    %     ind_i=find(tracks(:,1)==trkid(i));
    %     for j=i+1:length(trkid)
    %         ind_j=find(tracks(:,1)==trkid(j));
    %         cmn=ismember(tracks(ind_j,[2 3]),tracks(ind_i,[2 3]),'row');
    %         if sum(cmn)>0
    %             if length(ind_j)==length(cmn)
    %                 repeated_trk(j)=true;
    %             end
    %         end
    %     end
    %     
    % end
    % trkid=trkid(~repeated_trk);
    % trkidl=trkidl(~repeated_trk);
    % 
    % ind=ismember(tracks(:,1),trkid);
    % tracks=tracks(ind,:);

    %% split tracks with missing frames

    miss_frame=false(length(trkid),1);
    for i=1:length(trkid)
        ind=find(tracks(:,1)==trkid(i));
        if length(ind)<length(tracks(ind(1),2):tracks(ind(end),2))
            miss_frame(i)=true;
            possible_frms=tracks(ind(1),2):tracks(ind(end),2);
            ind2=ismember(possible_frms,tracks(ind,2));
            trk_seg=bwconncomp(ind2);
            for j=1:trk_seg.NumObjects
                ind3=ind(ismember(tracks(ind,2),possible_frms(trk_seg.PixelIdxList{1,j})));
                tracks(ind3,1)=max(tracks(:,1))+1;
            end
        end
    end

    % applying the minimum tracklen after splitting tracks
    tracks_smallBubbles = tracks(tracks(:,7) < maxRadius_minTrkLen,:);
    [C,ia,ib] = unique(tracks_smallBubbles(:,1));
%     for i=1:length(trkid)
%         trkidl(i)=sum(tracks_smallBubbles(:,1)==trkid(i));
%     end
    if size(ia,1) > 1
        trklen = ia(2:end) - ia(1:end-1);
        trklen(end+1) = size(tracks_smallBubbles,1) - ia(end) + 1;
    elseif size(ia,1) == 1
        trklen = size(tracks_smallBubbles,1) - ia + 1;
    else
        trklen = 0;
    end
    ind=ismember(tracks_smallBubbles(:,1),C(trklen > min_trk_l));
    tracks_smallBubbles=tracks_smallBubbles(ind,:);
    
    tracks(tracks(:,7) < maxRadius_minTrkLen,:) = [];
    tracks = [tracks_smallBubbles; tracks];
    
%      %% delete jumping tracks
%      [C,~,~] = unique(tracks(:,1));
%      delete = zeros(size(C,1), 1);
%      for i = 1 : size(C, 1)
%          track_one = tracks(tracks(:, 1) == C(i), :);
%          diff = vecnorm(track_one(1 : end - 1, 4 : 6) - track_one(2 : end, 4 : 6), 2, 2);
%          if sum(diff > mean(track_one(:, 7)))  % if the shift is more than one half of the radius, it is probably shifting due to the reason other than deformation.
%              delete(i) = 1;
%          end
%      end
%     for i = 1 : size(C, 1)
%         if delete(i)
%             tracks(tracks(:, 1) == C(i), :) = [];
%         end
%     end
%      
  %%  why do we need this?
    [C,~,~] = unique(tracks(:,1));
    tmp = (1+trID):(size(C,1)+trID);
%     trID = size(C,1)+trID;
    clear dummy
    for i = 1:size(C,1)
        dummy(:,i) = (tracks(:,1) == C(i));
    end
    for i = 1:size(C,1)
        tracks(dummy(:,i),1) = tmp(i); 
    end
    tracks = sortrows(tracks,1);
    
   
 %% filter bubble tracks   

    filterwidth = 3;
    fitwidth = 9;
    framerate = 4000;
    Bdata = ashwanth_rni_vel_accV2(tracks(:,[4 5 6 2 1]), './', filterwidth, fitwidth, framerate);

    ind=ismember(tracks(:,[1 2]),Bdata(:,[5 4]),'rows');
    tracks=tracks(ind,:);
    
 %% Rearrange the track ID to avoid repeated tracks   
    tmp = (1+trID):(size(C,1)+trID);
    trID = size(C,1)+trID;
    clear dummy
    for i = 1:size(C,1)
        dummy(:,i) = (tracks(:,1) == C(i));
    end
    for i = 1:size(C,1)
        tracks(dummy(:,i),1) = tmp(i); 
    end
%     tracks = sortrows(tracks,1);

    Bdata(:,[5 4]) = tracks(:,[1 2]);
    tracks = sortrows(tracks,1);
    Bdata = sortrows(Bdata, 5);
    tracks(:,21) = ones(1,size(tracks,1)).*hubs_2do(z);
    
    Bdata_all = [Bdata_all;Bdata(:, 1:11)];
    tracks_all = [tracks_all;tracks];
%     save([data_location 'Bubble_DataV2.mat'],'Bdata','tracks','maxRadius','minRadius','min_trk_l', 'filterwidth', 'fitwidth');
%     tmp = [data_location(1:63) 'AugustBubbles_smoothTracks/' data_location(79:end)];
%     save(tmp,'Bdata','tracks','maxRadius','minRadius','min_trk_l', 'filterwidth', 'fitwidth');
    if ~mod(z, 50)
        save('bubble_data.mat', 'tracks_all', 'Bdata_all', '-v7.3');
    end
end

save('bubble_data.mat', 'tracks_all', 'Bdata_all', '-v7.3');