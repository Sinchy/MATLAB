function track_breakup = Bubble_Data_2Find_Breakup_Main(calibpath, save_path, data_location_origin, data_location_reconstruct, frame_range, break_frame)
load(calibpath);

% save_path = '/home/tanshiyong/Documents/Data/Bubble/04.16.18/Run3/Bubbles2/';
% data_location_reconstruct='/media/Share2/Projects/1-Bubble/Cam_Config_of_04.04.18/Reconstruction/04.16.18/Run3/Bubbles2/';
% data_location_origin = '/media/Share1/Projects/Bubble/Cam_Config_of_04.04.18/Data/04.16.18/Run3/Bubbles2/' ;

frame1=frame_range(1);
frame2=frame_range(2);
min_trk_lngth=50;
min_rad=0.5;

[tracks,trkid,trkidl]=Bubble_Data_2Find_Breakup(data_location_reconstruct,frame1,frame2,min_trk_lngth,min_rad);

dum=dir(data_location_origin);

cam=3;
frame=break_frame;
sect_num = extractAfter(data_location_origin(1 : end -1), 'Bubbles');
% img_name=[data_location_origin  'C00' num2str(cam) '_H001S000' sect_num '/C00' num2str(cam) '_H001S000' sect_num num2str(frame,'%06i') '.tif'];
img_name=[data_location_origin  'Cam' num2str(cam) '/cam' num2str(cam) 'frame' num2str(frame,'%05i') '.tif'];
img=imread(img_name);
%%
figure
imshow(img)
hold on
for i=1:length(trkid)


    ind=find(tracks(:,1)==trkid(i));
    trk=tracks(ind,4:6);
    trk_frames=tracks(ind,2);
    Xtest_proj= calibProj_Tsai(camParaCalib, trk , cam);
    plot(Xtest_proj(:,1),Xtest_proj(:,2),'b.-')
    plot(Xtest_proj(trk_frames==frame,1),Xtest_proj(trk_frames==frame,2),'r*-')

    txt = ['\leftarrow ' num2str(trkid(i))];
    text(Xtest_proj(1,1),Xtest_proj(1,2),txt,'color','g')
% pause;
% clf;
end
prompt = {'Enter track ID of a father bubble:'};
title = 'Input';
dims = [1 35];
definput = {'0'};
trackID = inputdlg(prompt,title,dims,definput);
trackID = str2num(trackID{1});
% track_breakup = tracks(tracks(:, 1) == trackID, :);
% track_breakup = track_breakup(:, [4 5 6 2 1]);

prompt = {'Enter track ID of a son bubble:'};
title = 'Input';
dims = [1 35];
definput = {'0'};
trackID2 = inputdlg(prompt,title,dims,definput);
trackID2 = str2num(trackID2{1});
track_breakup = tracks(tracks(:, 1) == trackID | tracks(:, 1) == trackID2, :);
track_breakup = track_breakup(:, [4 5 6 2 1]);

%%get the surface of the bubble
mkdir([save_path 'Bubble_Surface/']);

brk_data = tracks(tracks(:,1) == trackID | tracks(:, 1) == trackID2,2:3);
brk_data = brk_data(brk_data(:,1) >= frame1 & brk_data(:,1) <= frame2,:);
frame_no = unique(brk_data(:,1));

% for j=1:size(brk_data,1)
parfor j = 1 : size(frame_no, 1)
    bubbles = brk_data(brk_data(:,1) == frame_no(j), :);
    fv = [];
    for k = 1 : size(bubbles, 1)
%         s_bubbles = load([data_location_reconstruct 'Bubble_Frame_' num2str(brk_data(j,1),'%06i') '.mat']);
        s_bubbles = load([data_location_reconstruct 'Bubble_Frame_' num2str(bubbles(k,1),'%06i') '.mat']);
%         ind = s_bubbles.bubbles(1,brk_data(j,2)) : s_bubbles.bubbles(2,brk_data(j,2));
        ind = s_bubbles.bubbles(1,bubbles(k,2)) : s_bubbles.bubbles(2,bubbles(k,2));
        [vx,vy,vz,vox] = map2grid(s_bubbles.voxels(ind,1),s_bubbles.voxels(ind,2),s_bubbles.voxels(ind,3),s_bubbles.voxel_size_2);
        vox = imfill(vox,'holes');
        ind = find(vox>0);
        fv = [fv; isosurface(vx,vy,vz,vox,0.999)];
    end
    filename = [ save_path 'Bubble_Surface/trk_' num2str(trackID) '_step_' num2str(j) '.stl'];
    nb=size(bubbles, 1);
    patch2stl_combineV2(filename, fv, nb);
end
end