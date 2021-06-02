function [ frame_range ] = traj_getFrameRange(tracks_combined)
% This function outputs the min and max frame that is observed in the
% trajectory dataset
%
% frame_range = [min_frame,  max_frame]

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

min_frame = inf;
max_frame = 0;

for k = 1:size(tracks_combined,2)
    cur_traj_frames = tracks_combined{k}(:,6);
    
    if min_frame > min(cur_traj_frames)
        min_frame = min(cur_traj_frames);
    end
    
    if max_frame < max(cur_traj_frames)
        max_frame = max(cur_traj_frames);
    end
end

% assign output value
frame_range = [min_frame max_frame];
end
