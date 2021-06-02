function [ camSystem ] = calibrateFromTarget( )
% This function calls the BoLi-Calibration-Toolbox. Existing target markers
% are used instead of the supposed patterns.

% load the target-image data:

exMarkerPoints = struct('pP',[],'iP',[],'isActive',[]);

% compose BoLi-compatible array of points
run_idx = 1;
filename = 1;
nCameras = 0;
while any(filename)
    filename = uigetfile('cameraX.mat','Choose camera target data');
    if any(filename)
        nCameras = nCameras+1;
        load(filename,'settings');
        for k = 1:length(settings.images)
            exMarkerPoints(run_idx).iP = settings.images(k).x;
            exMarkerPoints(run_idx).pP = settings.images(k).X;
            exMarkerPoints(run_idx).isActive = settings.images(k).isActive;
            run_idx = run_idx+1;
        end
        
        % store the image resolution for the boli-script
        height(nCameras)  = size(horzcat(settings.images.imData),1);
        width(nCameras) = size(vertcat(settings.images.imData),2);
    end
end

% start the calibration script
calibration_boli;
camSystem = obj;
end

