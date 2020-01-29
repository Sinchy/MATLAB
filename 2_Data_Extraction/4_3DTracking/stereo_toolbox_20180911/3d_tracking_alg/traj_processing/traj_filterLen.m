function [tracks_minLen] = traj_filterLen(tracks_combined, minLen)
% This function filters the trajectory set by length
% USAGE: filered_tracks = traj_filterLen(tracks_combined, minLen)

% mlint message suppression
%#ok<*AGROW>   

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

% initialize output array
if isstruct(tracks_combined)
    tracks_minLen = struct(tracks_combined(1));
else
    tracks_minLen = [];
end
idx = 1;


for k = 1:length(tracks_combined)
    % check for length of trajectory
    if isstruct(tracks_combined)
        if size(tracks_combined(k).position,1)>minLen
            % copy entry to output array
            tracks_minLen(idx) = tracks_combined(k);   
            idx = idx+1;
        end
    else
        if size(tracks_combined{k},1)>minLen
            % copy entry to output array
            tracks_minLen{idx} = tracks_combined{k};
            idx = idx+1;
        end
    end

end
