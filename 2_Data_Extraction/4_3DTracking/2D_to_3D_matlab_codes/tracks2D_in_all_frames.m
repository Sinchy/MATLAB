%% Getting the 2D tracks that contain particles in all the frames
frames = [5, 14];

for cam = 1:4
    eval(['tracks = tr' num2str(cam) ';']);
%     eval(['ind' num2str(cam) '= 0;']);
%     for i=unique(tracks(:,1)')
%         ind = find(tracks(:,1) == i);
%         tmp1 = tracks(ind,4);
%         if (ismember(5,tmp1) && ismember(15,tmp1))
%             eval(['ind' num2str(cam) '= [ind' num2str(cam) ';ind(1)];']);
%         end  
%     end
%     eval(['ind' num2str(cam) '(1)= [];']);

    eval(['ind' num2str(cam) '= find(tracks(:,4) == 5);']);
end