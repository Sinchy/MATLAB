%% path and file settings

% sprintf-readable image locations
% e.g. :    settings.cam1_filename =  '/somePath/CAM1_%05d.bmp';
%           settings.cam2_filename =  '/somePath/CAM2_%05d.bmp';
%           settings.cam3_filename =  '/somePath/CAM3_%05d.bmp';
%           settings.output2Dcoords = '/somePath/coords2d/coords_2d_%05.dat';
%clear STB_params;

SPT_params.nCams         = 4; % number of cameras used
SPT_params.cam1_filename = './cam1/image_%05d.png';
SPT_params.cam2_filename = './cam2/image_%05d.png';
SPT_params.cam3_filename = './cam3/image_%05d.png';
SPT_params.cam4_filename = './cam4/image_%05d.png';

% where to put the concatenated 2d-position files? (sprintf-readable)
% e.g. settings.output2Dcoords = './somePath/coords2d/coords_2d_%05.dat';
SPT_params.output2Dcoords = './coords2d/coords2d_%05d.dat';

% range of images to process
% e.g. settings.im_range = 1:1000 or [1 1000]
SPT_params.im_range = frame_range;

% check for file existence
SPT_params = image_file_check(SPT_params);


%% particle detection
% start the detection-GUI for each of the cameras (number = 2nd parameter)
% This will collect the detection parameters and store them into the
% "settings"-structure.
SPT_params = particle_detection_GUI(SPT_params,1);
SPT_params = particle_detection_GUI(SPT_params,2);
SPT_params = particle_detection_GUI(SPT_params,3);
SPT_params = particle_detection_GUI(SPT_params,4);

detect2d(SPT_params, 1);  % the second boolean argument triggers an graphical output 