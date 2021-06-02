function [ trajs ] = connectTrajectories( trajs, maxCostFrame, maxCostDistPerFrame )
% This function loads a trajectory dataset and tries to interpolate the gap
% between two (long) trajectories. If you want to force a connection set
% infinite maxCost* - parameters

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

% first step: visualize candidates

% sort trajectories by length
[traj_len] = traj_getLength(trajs);

[~ , I] = sort(traj_len);

trajs = trajs(I); % now the dataset is sorted by length (ascending)

for k = 1:length(trajs)
    % look for the closest (in time and place) ascendor candidate for the
    % curren trajectory:
    endPosition = trajs{k}(end,12:14);
    endFrame = trajs{k}(end,6);
    
    % get ALL ending-positions and all ending-frames:
    candEndPosition = zeros(length(trajs)-1,3);
    candEndFrame = zeros(length(trajs)-1,1);
    for kk = setdiff(1:length(trajs), k) % all but current
        candEndPosition(kk,:) = trajs{k}(end,12:14);
        candEndFrame(kk,1) = trajs{k}(end,6) ;
    end
    
    % find all candidates that are within the desired distance
    dist_pos   = distance3d(candEndPosition,endPosition);
    dist_frame = candEndFrame - endFrame*ones(size(candEndFrame,1),1);
    
    idx_dist_pos = find( dist_pos./dist_frame < maxCostDistPerFrame);
    idx_dist_frame = find( frame < maxCostFrame );
    
    idx_cand = intersect(idx_dist_pos,idx_dist_frame);
    
    if ~isempty(idx_cand)
        % Maybe there is a direct possible connection between two
        % trajectories. This has priority.
        for kk = idx_cand
            if dist_frame(kk)==1 %direct temporal connection
                if idx_dist_pos(kk)<maxCostDistPerFrame
                    % perfect. This 
                end
            end
        end
        
    end
    
end

end

