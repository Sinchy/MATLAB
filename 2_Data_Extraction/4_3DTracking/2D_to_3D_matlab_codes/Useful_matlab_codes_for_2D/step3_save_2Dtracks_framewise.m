dir = '/home/tanshiyong/Documents/Data/Bubble/08.01.18/Run1_Bubbles/Bubbles2/Bubbles2/2Dtracks/';

for cam = 1:4
    tr{cam} = load([dir 'tracks_cam' num2str(cam) '.mat'],'tracks');
    eval(['tr' num2str(cam) ' = cell2mat(tr(' num2str(cam) '));']);
    eval(['tr' num2str(cam) ' = tr' num2str(cam) '.tracks;']);
 end

start_frame = 2380; end_frame = 2819;
    totFrames = end_frame - start_frame;
 %%
 for frame = 1:totFrames
     ind1 = find(tr1(:,4)==frame); ind2 = find(tr2(:,4)==frame); 
     ind4 = find(tr4(:,4)==frame); ind3 = find(tr3(:,4)==frame); 
     indMax = max([numel(ind1) numel(ind2) numel(ind3) numel(ind4)]);
     
     a = zeros(indMax,16);   
     a(1:numel(ind1),[1 2 9 10 17]) = tr1(ind1,[2 3 5 6 1]);
     a(1:numel(ind2),[3 4 11 12 18]) = tr2(ind2,[2 3 5 6 1]);
     a(1:numel(ind3),[5 6 13 14 19 ]) = tr3(ind3,[2 3 5 6 1]);
     a(1:numel(ind4),[7 8 15 16 20]) = tr4(ind4,[2 3 5 6 1]);
     
     eval(['frame_' num2str(frame) '= a;']);
 end
 clear tr1 tr2 tr3 tr4 tr
 save([ dir 'allcams.mat']);
 
 %% 123
 for frame = 1:totFrames
     eval(['frame_' num2str(frame) '(:,[7:8 15:16 20])= 0;']);
 end
 
 save([ dir '123cams.mat']);
 
 %% 234
 
 load([ dir 'allcams.mat'])
 
 for frame =  1:totFrames
     eval(['frame_' num2str(frame) '(:,[1:6 9:14 17:19])= frame_' num2str(frame) '(:,[3:8 11:16 18:20]);']);
     eval(['frame_' num2str(frame) '(:,[7:8 15:16 20])= 0;']);
 end
 
 save([ dir '234cams.mat']);
 
  %% 134
  
  load([ dir 'allcams.mat'])
  
 for frame =  1:totFrames
     eval(['frame_' num2str(frame) '(:,[3:6 11:14 18:19])= frame_' num2str(frame) '(:,[5:8 13:16 19:20]);']);
     eval(['frame_' num2str(frame) '(:,[7:8 15:16 20])= 0;']);
 end
 
 save([ dir '134cams.mat']);
 
   %% 124
   
   load([ dir 'allcams.mat'])
   
 for frame =  1:totFrames
     eval(['frame_' num2str(frame) '(:,[5:6 13:14 19])= frame_' num2str(frame) '(:,[7:8 15:16 20]);']);
     eval(['frame_' num2str(frame) '(:,[7:8 15:16 20])= 0;']);
 end
     
save([ dir '124cams.mat']);
 
 %% 12

 load([ dir '123cams.mat']);
    
 for frame =1:totFrames
     eval(['frame_' num2str(frame) '(:,[5:8 13:16 19])= 0;']);
 end
 
 save([ dir '12cams.mat']);
 
   %% 13
  
  load([ dir '134cams.mat']);
  
 for frame =  1:totFrames
    eval(['frame_' num2str(frame) '(:,[5:6 13:14 19])= 0;']);
 end
 
 save([ dir '13cams.mat']);
 
    %% 14
   
   load([ dir 'allcams.mat'])
   
 for frame =  1:totFrames
     eval(['frame_' num2str(frame) '(:,[3:4 11:12 18])= frame_' num2str(frame) '(:,[7:8 15:16 20]);']);
     eval(['frame_' num2str(frame) '(:,[5:8 13:16 19 20])= 0;']);
 end
     
 save([ dir '14cams.mat']);
  
     %% 23
   
   load([ dir '234cams.mat']);
   
 for frame =  1:totFrames
     eval(['frame_' num2str(frame) '(:,[5:6 13:14 19])= 0;']);
 end
     
 save([ dir '23cams.mat']);
 
      %% 24
   
   load([ dir '234cams.mat']);
   
 for frame =  1:totFrames
     eval(['frame_' num2str(frame) '(:,[3:4 11:12 18])= frame_' num2str(frame) '(:,[5:6 13:14 19]);']);
     eval(['frame_' num2str(frame) '(:,[5:6 13:14 19])= 0;']);
 end
     
 save([ dir '24cams.mat']);
 
       %% 34
   
   load([ dir '234cams.mat']);
   
 for frame =  1:totFrames
     eval(['frame_' num2str(frame) '(:,[1:4 9:12 17 18 ])= frame_' num2str(frame) '(:,[3:6 11:14 18 19]);']);
     eval(['frame_' num2str(frame) '(:,[5:6 13:14 19])= 0;']);
 end
     
 save([ dir '34cams.mat']);
 