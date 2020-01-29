save_path = '/home/tanshiyong/Documents/Data/Single-Phase/11.03.17/Run1/Tracks/ConvergedTracks/interest1/';
load /home/tanshiyong/Documents/Data/Single-Phase/11.03.17/Run1/VSC_Calib_11.02.17.mat;
mkdir(save_path);
% x = 469; y = 589;
point = [-5.05723940000000,3.67690270000000,-0.456430870000000];
proj = calibProj_Tsai(camParaCalib(1), point);
x = proj(1); y = proj(2);
delta = 40;
for i = 872 : 877
    img = imread(['/home/tanshiyong/Documents/Data/Single-Phase/11.03.17/Run1/cam1/cam1frame' num2str(i, '%05.0f') '.tif']);
    imwrite(img(y - delta : y + delta, x - delta : x + delta ), [save_path 'cam1frame0' num2str(i) '.tif'])
end