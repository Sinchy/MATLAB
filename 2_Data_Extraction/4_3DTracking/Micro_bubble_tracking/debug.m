%% Read correlation map
fileID = fopen("D:\1.Projects\Bubble_Particles\DataProcessing\Synthetic5\Debug\imgcor.txt",'r');
formatspec = '%f,';
r_map = fscanf(fileID, formatspec);
% dim = [27, 26];
% r_map = reshape(r_map, [length(r_map)^.5 length(r_map)^.5]);
r_map = reshape(r_map, dim);
r_map(r_map(:)<0) = 0;
figure
surf(r_map)
axis equal
view(0, 90)
set(gca,  'Ydir', 'reverse');

%% Read augresimg
% dim = [28, 28];
 augresimg = ReadBubbleImage("D:\1.Projects\Bubble_Particles\DataProcessing\Synthetic5\Debug\augresimg.txt", dim);
 %% 
 
 %% Read origin image
 img = ReadBubbleImage("C:\Users\ShiyongTan\Documents\Data_processing\20220310\T2\S1\Debug\img.txt");
 %%
 posnew = [-0.46, 12.38, -10.26];
 cam2D_1 = calibProj(camParaCalib(1), posnew);
 cam1_img = imread("C:\Users\ShiyongTan\Documents\Data_processing\20220310\T2\S1\cam_1\cam1frame000017.tif");
 figure
 imshow(cam1_img);
 hold on
 plot(cam2D_1(1), cam2D_1(2), '*')
