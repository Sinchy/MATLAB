%% path and file settings

% sprintf-readable image locations
% e.g. :    settings.cam1_filename =  '/somePath/CAM1_%05d.bmp';
%           settings.cam2_filename =  '/somePath/CAM2_%05d.bmp';
%           settings.cam3_filename =  '/somePath/CAM3_%05d.bmp';
%           settings.output2Dcoords = '/somePath/coords2d/coords_2d_%05.dat';
clear settings;

settings.nCams         = 3; % number of cameras used
settings.cam1_filename = './EXAMPLE/ParticleImages/Cam1/cam1_%05d.bmp';
settings.cam2_filename = './EXAMPLE/ParticleImages/Cam2/cam2_%05d.bmp';
settings.cam3_filename = './EXAMPLE/ParticleImages/Cam3/cam3_%05d.bmp';
% settings.cam4_filename = ...

% where to put the concatenated 2d-position files? (sprintf-readable)
% e.g. settings.output2Dcoords = './somePath/coords2d/coords_2d_%05.dat';
settings.output2Dcoords = './EXAMPLE/Coords2d/coords_2d_%05d.dat';

% range of images to process
% e.g. settings.im_range = 1:1000 or [1 1000]
settings.im_range = 1:19;

% check for file existence
settings = image_file_check(settings);


%% particle detection
% start the detection-GUI for each of the cameras (number = 2nd parameter)
% This will collect the detection parameters and store them into the
% "settings"-structure.
settings = particle_detection_GUI(settings,1);
settings = particle_detection_GUI(settings,2);
settings = particle_detection_GUI(settings,3);
% settings = particle_detection_GUI(settings,4);
% ...

detect2d(settings, 1);  % the second boolean argument triggers an graphical output 