% this script calls the relevant subfunctions to calibrate a system of 3
% cameras using a calibration target

% the calibration uses N+1 steps:
%   Step 1-N:  locate (and load) the calibration images for all N cameras
%   and save the results (each)
%   Step N+1: compute intrinsic and extrinsic parameters



%% locate (and load) the calibration images for each image set
% repeat this step for each set of camera images. Be sure to start with the
% very first image of each sequence!

imageLocations = locateCalibImages;

% be sure, that the dX and dY variables are set according to your grid. The
% dX and dY are the distances from one marker-center to the center of its
% neighboring marker. The variables are hard-coded in
% "processTargetImages.m".
settings = autoCalibSettings_GUI(imageLocations);

% save the results!!
saveCalibration(); % saves the settings-struct and "imageLocations"-variable

%% run the actual (intrinsic+) calibration with the collected calibration data
% when all camera-files have been loaded, press "Cancel"
cameraSystem = calibrateFromTarget();

[filename, pathname] = uiputfile('cameraSystem.mat','Save Calib Results as...');
if any(filename)
    save(fullfile(pathname, filename),'cameraSystem');
else
    warndlg('The cameraSystem-Object has not been saved yet');
end


%% (optional) you might align your camera system
%cameraSystem.align;

% view the resulting rig
cameraSystem.visualizeObjects;

% to get the projection matrices, use:
[P1, P2, P3] = cameraSystem.getProjectionMatrices;
