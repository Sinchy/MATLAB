 for cam = 1:4
    tr{cam} = load(['tracks_cam' num2str(cam) '.mat'],'tracks');
    eval(['tr' num2str(cam) ' = cell2mat(tr(' num2str(cam) '));']);
    eval(['tr' num2str(cam) ' = tr' num2str(cam) '.tracks;']);
 end

 frames = 200;
 %%
 for frame = 1:frames
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
 save allcams.mat
 
 %% 123
 for frame = 1:frames
     eval(['frame_' num2str(frame) '(:,[7:8 15:16])= 0;']);
 end
 
 save 123cams.mat
 
 %% 234
 
 load allcams.mat
 
 for frame =  1:frames
     eval(['frame_' num2str(frame) '(:,[1:6 9:14 17:19])= frame_' num2str(frame) '(:,[3:8 11:16 18:20]);']);
     eval(['frame_' num2str(frame) '(:,[7:8 15:16 20])= 0;']);
 end
 
 save 234cams.mat
 
  %% 134
  
  load allcams.mat
  
 for frame =  1:frames
     eval(['frame_' num2str(frame) '(:,[3:6 11:14 18:19])= frame_' num2str(frame) '(:,[5:8 13:16 19:20]);']);
     eval(['frame_' num2str(frame) '(:,[7:8 15:16 20])= 0;']);
 end
 
 save 134cams.mat
 
   %% 124
   
   load allcams.mat
   
 for frame =  1:frames
     eval(['frame_' num2str(frame) '(:,[5:6 13:14 19])= frame_' num2str(frame) '(:,[7:8 15:16 20]);']);
     eval(['frame_' num2str(frame) '(:,[7:8 15:16 20])= 0;']);
 end
     
 save 124cams.mat
 
 %% 12

 load 123cams.mat
    
 for frame = 1:frames
     eval(['frame_' num2str(frame) '(:,[5:8 13:16])= 0;']);
 end
 
 save 12cams.mat
 
   %% 13
  
  load 134cams.mat
  
 for frame =  1:frames
    eval(['frame_' num2str(frame) '(:,[5:6 13:14])= 0;']);
 end
 
 save 13cams.mat
 
    %% 14
   
   load allcams.mat
   
 for frame =  1:frames
     eval(['frame_' num2str(frame) '(:,[3:4 11:12])= frame_' num2str(frame) '(:,[7:8 15:16]);']);
     eval(['frame_' num2str(frame) '(:,[5:8 13:16])= 0;']);
 end
     
 save 14cams.mat
  
     %% 23
   
   load 234cams.mat
   
 for frame =  1:frames
     eval(['frame_' num2str(frame) '(:,[5:6 13:14])= 0;']);
 end
     
 save 23cams.mat
 
      %% 24
   
   load 234cams.mat
   
 for frame =  1:frames
     eval(['frame_' num2str(frame) '(:,[3:4 11:12])= frame_' num2str(frame) '(:,[5:6 13:14]);']);
     eval(['frame_' num2str(frame) '(:,[5:6 13:14])= 0;']);
 end
     
 save 24cams.mat
 
       %% 34
   
   load 234cams.mat
   
 for frame =  1:frames
     eval(['frame_' num2str(frame) '(:,[1:4 9:12])= frame_' num2str(frame) '(:,[3:6 11:14]);']);
     eval(['frame_' num2str(frame) '(:,[5:6 13:14])= 0;']);
 end
     
 save 34cams.mat
 