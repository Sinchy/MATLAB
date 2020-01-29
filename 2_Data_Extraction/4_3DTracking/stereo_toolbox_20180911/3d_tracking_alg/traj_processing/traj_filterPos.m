function [ tracks_Range ] = traj_filterPos ( tracks_combined, coord, coord_range, perc_in_range )
% this function reduces the dataset to trajectories that lie to
% "perc_in_range"-percent within the given z_range.
% coord: 1=x, 2=y, 3=z

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

% inputs:
if nargin <3 , perc_in_range = 100; end


keep = false(size(tracks_combined,2),1);

% main processing loop
for k = 1:size(tracks_combined,2)
    % check for in-range-positions of trajectory
    switch coord
        case 1,
            in_range = tracks_combined{k}(:,12)>min(coord_range) & tracks_combined{k}(:,12)<max(coord_range);
        case 2,
            in_range = tracks_combined{k}(:,13)>min(coord_range) & tracks_combined{k}(:,13)<max(coord_range);
        case 3,            
            in_range = tracks_combined{k}(:,14)>min(coord_range) & tracks_combined{k}(:,14)<max(coord_range);
    end
    
    % check percent-condition
    perc_in_range_cur = 100*numel(nonzeros(in_range))/numel(in_range);
    
    if perc_in_range_cur >= perc_in_range
        keep(k) = true;
    end
end

% assign kept tracks
tracks_Range = tracks_combined(keep);


end
