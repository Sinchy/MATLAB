function [ disparityArray, disparityMap ] = getDisparityMap( cameraSystem, camNo )
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

%% preferences
frame_range = 800:850;
fmask3d = './coords3d/cam123/coords3d_%05d.dat';
[P1, P2, P3] = cameraSystem.getProjectionMatrices;
voxelSize = 1; % in mm
voxelTotalNumber = 5*5*5; % Nx*Ny*Nz

%% initialization
% initialize the voxel-array
NvoxPerAx = ceil(voxelTotalNumber.^(1/3));
edges = -(NvoxPerAx/2)*voxelSize : voxelSize : (NvoxPerAx/2)*voxelSize;
gridCounts = zeros(NvoxPerAx,NvoxPerAx, NvoxPerAx);

disparityArray = cell(numel(frame_range),1);

disparityMap = cell(3,1); % three cameras
for k = 1:3, disparityMap{k} = zeros(NvoxPerAx, NvoxPerAx,NvoxPerAx, 51,51); end
[GridX, GridY] = meshgrid(-25:25, -25:25);  % used for the gauss-blobs later on


%% get reprojection errors
figure; 
for f = frame_range
    data = dlmread(sprintf(fmask3d,f));
    disparityArray{f-min(frame_range)+1} = zeros(size(data,1),9);
    plot3(data(:,1), data(:,2), data(:,3),'b.'); hold on
    for p = 1:size(data,1)
        c2d1 = data(p,4:5);
        c2d2 = data(p,6:7);
        c2d3 = data(p,8:9);
        
        [coords3d, disparity] = triangulateFrom3Cameras(c2d1, c2d2, c2d3, P1, P2, P3);
        
        % build disparity map for this frame
        disparityArray{f-min(frame_range)+1}(p,:) = generateDisparityArray(coords3d, disparity);
    end
end

% normalize all subimages
for camNo = 1:3
    for k = 1:NvoxPerAx
        for kk = 1:NvoxPerAx
            for kkk = 1:NvoxPerAx
                map_temp = squeeze( disparityMap{camNo}(k,kk,kkk,:,:));
                map_temp = map_temp./max(map_temp(:));
                disparityMap{camNo}(k,kk,kkk,:,:) = map_temp;
            end
        end
    end
end


%% nested functions
    function map = generateDisparityArray(c3d, disparity)
        % use the 3d coordinates to fill in all disparity vectors to the voxel
        % they belong.
        [~, ~, binIdx.x ] = histcounts(c3d(1),edges);
        [~, ~, binIdx.y ] = histcounts(c3d(2),edges);
        [~, ~, binIdx.z ] = histcounts(c3d(3),edges);
        
        
        if  ~(binIdx.x==0 || binIdx.y==0 || binIdx.z==0)
            
            % the map will be an array with:
            % columns 1:6 : disparity vector x-y for each camera
            % columns 7:9 : voxel indices
            map = [ disparity.cam1.x, disparity.cam1.y ,...
                disparity.cam2.x, disparity.cam2.y, ...
                disparity.cam3.x, disparity.cam3.y, ...
                binIdx.x, binIdx.y, binIdx.z  ];

            % update gridcounts-array
            gridCounts(binIdx.x, binIdx.y, binIdx.z) = gridCounts(binIdx.x, binIdx.y, binIdx.z) +1;
            
            % update the 3D2C disparity map containing 50x50 px
            map2dOld = squeeze( disparityMap{1}( binIdx.x, binIdx.y, binIdx.z, :, :));
            map2dNew = exp(- ((GridX-disparity.cam1.x*10).^2 + (GridY-disparity.cam1.y*10).^2)./5  );
            disparityMap{1}( binIdx.x, binIdx.y, binIdx.z, :, :) = map2dOld+map2dNew;
            
            map2dOld = squeeze(disparityMap{2}( binIdx.x, binIdx.y, binIdx.z, :, :));
            map2dNew = exp(- ((GridX-disparity.cam2.x*10).^2 + (GridY-disparity.cam2.y*10).^2)./5  );
            disparityMap{2}( binIdx.x, binIdx.y, binIdx.z, :, :) = map2dOld+map2dNew;
            
            map2dOld = squeeze(disparityMap{3}( binIdx.x, binIdx.y, binIdx.z, :, :));
            map2dNew = exp(- ((GridX-disparity.cam3.x*10).^2 + (GridY-disparity.cam3.y*10).^2)./5  );
            disparityMap{3}( binIdx.x, binIdx.y, binIdx.z, :, :) = map2dOld+map2dNew;

        else
            map = NaN(1,9);
        end
    end



end


