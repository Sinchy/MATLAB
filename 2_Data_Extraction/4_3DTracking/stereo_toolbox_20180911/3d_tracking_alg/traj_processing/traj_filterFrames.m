function [ traj_filtFrames ] = traj_filterFrames ( tracks_combined, frame_range, allowed_perc_out )
% This function filters the trajectory dataset for a given frame range. A
% percentage can be given that allowes trajectories to cross the
% frame-border to a certain amount - this might help to keep especially
% long trajectories.
% 
% If traj_filterLen is also used, it should be applied BEFORE.
% allowed_perc_out must be given from 0...100

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

if nargin ==2
    allowed_perc_out = 0;
end

% print out warning for percentag if number 0..1 is given
if allowed_perc_out>0 && allowed_perc_out<=1
    warning(sprintf('Warning: Percentage is meant to range from 0...100. Value entered is %f.',allowed_perc_out));
end

keep = false(size(tracks_combined));

for k = 1: size(tracks_combined,2)
    cur_traj_frames = tracks_combined{k}(:,6);
    % check for complete trajectory within frame_range
    if min(cur_traj_frames)>min(frame_range) && max(cur_traj_frames)<max(frame_range)
        keep(k) = true;
    end
    
    % check for partial trajectory within frame_range
    if allowed_perc_out
        matching_frames = intersect(cur_traj_frames, min(frame_range):max(frame_range));
        % inside-part of traj large enough?
        if numel(matching_frames)/numel(cur_traj_frames)>=1-allowed_perc_out/100
            keep(k) = true;
        end
    end
end

% assign output dataset
traj_filtFrames = tracks_combined(keep);

end
