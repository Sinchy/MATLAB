%% path and file settings

% sprintf-readable image locations
% e.g. :    settings.cam1_filename =  '/somePath/CAM1_%05d.bmp';
%           settings.cam2_filename =  '/somePath/CAM2_%05d.bmp';
%           settings.cam3_filename =  '/somePath/CAM3_%05d.bmp';
%           settings.output2Dcoords = '/somePath/coords2d/coords_2d_%05.dat';
%clear STB_params;

STB_params.nCams         = 4; % number of cameras used
STB_params.cam1_filename = './cam1/image_%05d.png';
STB_params.cam2_filename = './cam2/image_%05d.png';
STB_params.cam3_filename = './cam3/image_%05d.png';
STB_params.cam4_filename = './cam4/image_%05d.png';

% where to put the concatenated 2d-position files? (sprintf-readable)
% e.g. settings.output2Dcoords = './somePath/coords2d/coords_2d_%05.dat';
STB_params.output2Dcoords = './coords2d/coords2d_%05d.dat';

% range of images to process
% e.g. settings.im_range = 1:1000 or [1 1000]
STB_params.im_range = 31:41;

% check for file existence
STB_params = image_file_check(STB_params);


%% particle detection
% start the detection-GUI for each of the cameras (number = 2nd parameter)
% This will collect the detection parameters and store them into the
% "settings"-structure.
STB_params = particle_detection_GUI(STB_params,1);
STB_params = particle_detection_GUI(STB_params,2);
STB_params = particle_detection_GUI(STB_params,3);
STB_params = particle_detection_GUI(STB_params,4);
% ...

% we just want to collect the neccessary settings for the STB_algorithm. It
% is not neccessary to carry out an actual 2d-detection here.
%detect2d(STB_params, 1);  % the second boolean argument triggers an graphical output 