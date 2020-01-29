function [ tracks_cut ] = traj_cutFrames( tracks, frame_range )
% usage: [ tracks_cut ] = traj_cutFrames( tracks, frame_range )
% This function cuts off all trajectories and points of a trajectory that
% lie outside of the specified frame range
% 
% Inputs:
%     -tracks : usual...
%     -frame_range: min and max frame, e.g.: [1500 2000]
% Outputs:
%     -tracks_cut : residual tracks/trajectories

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

del_tracks = [];

fprintf(1,'Cutting trajectory ');
for k = 1:length(tracks)
    
    if mod(k,10)==0, fprintf(1,'%05d/%05d',k,length(tracks)); end
    for kk = 1:size(tracks{k},1)
        if ~any( ismember(tracks{k}(:,6), frame_range(1):frame_range(2)) )
            del_tracks = [del_tracks ; k]; % trajectory is everywhere out of range and can be deleted
        else % only partial rows have to be deleted
            tracks{k}(~ismember(tracks{k}(:,6), frame_range(1):frame_range(2)), :) = []; % delete outside rows
        end
    end
    if mod(k,10)==9, fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b'); end
end
fprintf(1,' [ done ]\n');
tracks(del_tracks) = [];
tracks_cut = tracks;


end

