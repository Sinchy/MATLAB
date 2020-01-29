%--------------------------------------------------------------------------
%     Copyright (C) 2016 Michael Himpel (himpel@physik.uni-greifswald.de)
%     
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------

display('----------------------------------------------------------------------'); 
display('Multiple-Camera Calibration Toolbox'); 

obj = CameraSystemCalibration(nCameras, rand(100,100)); 

display('### Camera Type'); 
CAMERA_TYPE={'PinholeCamera', 'CataCamera'}; 
cameraType = cell(nCameras, 1); 

cameraType{1} = CAMERA_TYPE{1};

if (nCameras > 1)
    for i = 2:nCameras
        cameraType{i} = CAMERA_TYPE{1};
    end
end


display('----------------------------------------------------------------------'); 
display('### Process Images'); 
% Initialize mono camera calibration models first
for i = 1:nCameras
    obj.setCameraType(i, cameraType{i}, width(i), height(i)); 
end


for i = 1:numel(exMarkerPoints)
    %obj.addPhoto(photos(i).camera, photos(i).image, num2str(photos(i).timeStamp)); 
    markerData = exMarkerPoints(i);
    imagesPerCamera = length(exMarkerPoints)/nCameras;
    
    cam_index = fix((0:length(exMarkerPoints)-1)/imagesPerCamera)+1;
    
    key = mod(0:numel(exMarkerPoints)-1,numel(exMarkerPoints)/nCameras)+1;  % image number per camera
    
    % check whether the image is "active" or should not be used
    if ~isempty(exMarkerPoints(i).isActive)
        if ((exMarkerPoints(i).isActive) && (~isempty(exMarkerPoints(i).iP)) )
            obj.addPhoto(cam_index(i), markerData, num2str(key(i)));
        else
            obj.addPhoto(cam_index(i), [] , num2str(key(i)));
        end
    else
        obj.addPhoto(cam_index(i), [] , num2str(key(i)));
    end
end
clear photos;

display('----------------------------------------------------------------------'); 
display('### Process Calibration'); 
obj.calibrate(); 
display('### Calibration finished'); 


display('----------------------------------------------------------------------'); 
display('### Intrinsics: '); 
obj.outputIntrinsics(); 
display('### Extrinsics: '); 
obj.outputExtrinsics(); 

input('Press ENTER to visualize camera poses plot and pose graph'); 
obj.visualizeObjects(); 
obj.visualizeGraph(); 


