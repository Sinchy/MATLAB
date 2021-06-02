function [ disparityArray, disparityMap ] = getDisparityMap2D( cameraSystem, settings )
% This funtion refines the calibration using the "Volume self-calibration
% for 3D particle image velocimetry by B. Wieneke, Exp Fluids (2008)
% 45:549-556.
% Implementation by M. Himpel, Univ.Greifswald, 2016

% The disparity map is a "user-readable" interpretation of the reprojection
% errors resulting from a misaligned camera calibration. In contrast to the 
% assumtion of a tomo-piv-system, arbitrarily aligned systems are supported.
% So, each camera gets "its own" disparity map, where the voxels are
% aligned perpenticular to its viewing axis. This allows a direct
% observation of hotizontal/vertical shifts in the reprojections. 
%
% Use the plotDisparityMap-function to show the results.
%
% 2D-Version: The disparity map is a 2D object covering the image plane. No
% voxels are needed for this case.
%
% This function is best called by "do_disparityRefinement.m"

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
%% preferences
frame_range = settings.disparityRefinement.frameRange;
fmask3d = [settings.triangulation.outputPaths{1} '/coords3d_%05d.dat' ];


P = cameraSystem.getProjectionMatrices;
subRes = settings.disparityRefinement.subRes; % resolution of sub maps
Nx = settings.disparityRefinement.Nx; % no of maps in x
Ny = settings.disparityRefinement.Ny; % no of maps in y


%% initialization
resX = cameraSystem.cameraCalibrations(1).camera.width;
resY = cameraSystem.cameraCalibrations(1).camera.height;
edges_x = linspace(1,resX,Nx);
edges_y = linspace(1,resY,Ny);
gridCounts = zeros(Nx,Ny);

disparityArray = cell(numel(frame_range),cameraSystem.nCameras);

subRes2 = ceil(subRes/2); 

disparityMap = cell(cameraSystem.nCameras,1);
for k = 1:cameraSystem.nCameras
    disparityMap{k} = zeros(Nx, Ny, length(-subRes2 : subRes2),  length(-subRes2 : subRes2));
end
[GridX, GridY] = meshgrid(-subRes2 : subRes2, -subRes2 : subRes2);  % used for the gauss-blobs later on


%% get reprojection errors
fprintf(1,'Disparity map:: Processing frame: ');
for f = frame_range
    fprintf(1,sprintf('%05d/%05d',f,max(frame_range)));
    data = dlmread(sprintf(fmask3d,f));
    
    
    parts2d = cell(cameraSystem.nCameras,1);
    column_idx = 1;
    for noOfCam = settings.triangulation.sets(1,:)
        parts2d{noOfCam} = data(:,3+2*column_idx-1 : 3+2*column_idx);
        column_idx = column_idx+1;
    end
    
    keyboard
    
    % generate a minimal camera set for triangulation:
%     A = tril(ones(cameraSystem.nCameras),-1);
%     [I, J] = find(A);
%     pairs = [I, J];
%     pairs = pairs(1:cameraSystem.nCameras-1,:);

    %[~, disparity] = triangulateFromNCameras(parts2d, P);
    
    keyboard
    % build disparity map for this frame
    for camNo = 1:cameraSystem.nCameras
        for partNo = 1:size(parts2d{camNo},1)
            [~, disparity{partNo}] = triangulateFromNCameras(parts2d, P);
        end
        
        disparityArray{f-min(frame_range)+1,camNo} = zeros(size(data,1),4);
        disparityArray{f-min(frame_range)+1,camNo}(p,:) = generateDisparityArray( parts2d{camNo}, disparity, camNo);
    end
    
    
    fprintf('\b\b\b\b\b\b\b\b\b\b\b');
end

% normalize all subimages to intensity 1
for cam = 1:cameraSystem.nCameras
    for k = 1:Nx
        for kk = 1:Ny
            map_temp = squeeze( disparityMap{cam}(k,kk,:,:));
            map_temp = map_temp./max(map_temp(:));
            disparityMap{cam}(k,kk,:,:) = map_temp;
        end
    end
end
fprintf(1,' [ done ]\n');

%% nested functions
    function map = generateDisparityArray(coords, disp_vec, camNo)
        % use the 3d coordinates to fill in all disparity vectors to the
        % map they belong.
        [~, ~, binIdx.x ] = histcounts(coords(:,1),edges_x);
        [~, ~, binIdx.y ] = histcounts(coords(:,2),edges_y);
        
        
        if  ~(binIdx.x==0 || binIdx.y==0 )

            % the map will be an array with:
            % columns 1:2 : disparity vector x-y for each camera
            % columns 3:4 : voxel indices
            
            map = [ disp_vec.x, disp_vec.y ,...
                binIdx.x, binIdx.y  ];

            % update gridcounts-array
            gridCounts(binIdx.x, binIdx.y) = gridCounts(binIdx.x, binIdx.y) +1;
            
            % update the 2D disparity map by putting a gaussian blob at the
            % position of the disparity vector
            keyboard
            map2dOld = squeeze( disparityMap{camNo}( binIdx.x, binIdx.y, :, :));
            map2dNew = exp(- ((GridX-disp_vec.x*10).^2 + (GridY-disp_vec.y*10).^2)./50  );
            disparityMap{camNo}( binIdx.x, binIdx.y, :, :) = map2dOld+map2dNew;
        else
            map = NaN(1,4);
        end
    end

end


