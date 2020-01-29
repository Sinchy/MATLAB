function [tracks,trkid,trkidl]=Bubble_Data_2Find_Breakup(data_location,frame1,frame2,min_trk_lngth,min_rad)

t=load([data_location 'tracks.mat']);
tracks=t.tracks;
t=[];

ind=tracks(:,12)>-1;
tracks=tracks(ind,:);


ind = tracks(:,2)>=frame1 & tracks(:,2)<=frame2 & tracks(:,7)>=min_rad;

min_trk_l=min_trk_lngth;

trkid=unique(tracks(ind,1));
trkidl=zeros(length(trkid),1);
for i=1:length(trkid)
    trkidl(i)=sum(tracks(:,1)==trkid(i));
end
trkid=trkid(trkidl>min_trk_l);
trkidl=trkidl(trkidl>min_trk_l);
ind=ismember(tracks(:,1),trkid);
tracks=tracks(ind,:);

%% remove duplicate tracks

[trkidl,sort_ind]=sort(trkidl,'descend');
trkid=trkid(sort_ind);
repeated_trk=false(length(trkid),1);
for i=1:length(trkid)-1
    ind_i=find(tracks(:,1)==trkid(i));
    for j=i+1:length(trkid)
        ind_j=find(tracks(:,1)==trkid(j));
        cmn=ismember(tracks(ind_j,[2 3]),tracks(ind_i,[2 3]),'row');
        if sum(cmn)>0
            if length(ind_j)==length(cmn)
                repeated_trk(j)=true;
            end
        end
    end
    
end
trkid=trkid(~repeated_trk);
trkidl=trkidl(~repeated_trk);

ind=ismember(tracks(:,1),trkid);
tracks=tracks(ind,:);

ind = tracks(:,7)>=min_rad;
tracks=tracks(ind,:);

%% split tracks with missing frames
split=0;

if split==1
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

trkid=unique(tracks(:,1));
trkidl=zeros(length(trkid),1);
for i=1:length(trkid)
    trkidl(i)=sum(tracks(:,1)==trkid(i));
end
trkid=trkid(trkidl>min_trk_l);
trkidl=trkidl(trkidl>min_trk_l);
ind=ismember(tracks(:,1),trkid);
tracks=tracks(ind,:);

end
