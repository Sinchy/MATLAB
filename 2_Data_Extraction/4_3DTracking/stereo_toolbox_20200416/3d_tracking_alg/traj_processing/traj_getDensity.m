function [ density, x_voxel_edges, y_voxel_edges, z_voxel_edges ] = traj_getDensity( tracks, grid )
% computes the particle density array on given 3D-voxel-grid
%
% inputs:
%       -tracks:    as usual
%       -grid:      grid as [ nx ny nz ] array, e.g. [15 15 15]
%
% outputs:
%       -density:   3D-array with density informations of the form
%                       density(5,10,3) = density at the voxel {x=5,y=10,z=3}
%       -..._grid_coords: coordinates of voxel centers in same order as
%       density-array

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

%% get edges for histc ( real-position of bin-edges)
[x_range, y_range, z_range ] = traj_getPosRange(tracks);
x_voxel_edges = linspace(x_range(1), x_range(2), grid(1)+1);
y_voxel_edges = linspace(y_range(1), y_range(2), grid(2)+1);
z_voxel_edges = linspace(z_range(1), z_range(2), grid(3)+1);



%% prepare variables
frame_range = traj_getFrameRange(tracks);
density = cell(max(frame_range)-min(frame_range)+1,1);
% initialize with zeros
for fr = 1:length(density)
    for kx = 1:grid(1)
    for ky = 1:grid(2)
    for kz = 1:grid(3)
        density{fr}(kx,ky,kz) = 0;
    end
    end
    end
end


%% sort particles into voxels and count
fprintf(1,'Trjectory: ');
for traj = 1:length(tracks)
    fprintf(1,'%05d/%05d',traj, length(tracks));
    % x-position
    [ binX, ~ ] = binData( tracks{traj}(:,12), x_range(1), x_range(2), grid(1) );
    
    % y-position
    [ binY, ~ ] = binData( tracks{traj}(:,13), y_range(1), y_range(2), grid(2) );

    % z-position
    [ binZ, ~ ] = binData( tracks{traj}(:,14), z_range(1), z_range(2), grid(3) );

    % in which frame do they exist? doStroboscope before this.
    inFrame = tracks{traj}(:,6)-min(frame_range)+1;
    cntBins = 1;
    for cntFr = inFrame'
    	density{cntFr}(binX(cntBins),binY(cntBins),binZ(cntBins)) = density{cntFr}(binX(cntBins),binY(cntBins),binZ(cntBins)) + 1;
        cntBins = cntBins + 1;
    end
    fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b');
end
fprintf(1,' done\n');
%% create output array


