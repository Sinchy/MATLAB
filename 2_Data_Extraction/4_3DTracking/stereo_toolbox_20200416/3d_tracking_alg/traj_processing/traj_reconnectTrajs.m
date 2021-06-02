function [ trajs ] = traj_reconnectTrajs( trajs )
% This function looks for disconnected trajectories. Sometimes, few frames
% later there are new trajectories available that continue the existing
% ones.

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

gap_width = 2;
dist_allowed = 0.05;


for k = 1:length(trajs)
    end_frame = trajs{k}(end,6);
    
    % now find trajectories that start at end+0...end+gap
    start_frames = [];
    for kk = 1:length(trajs)
        start_frames(kk) = trajs{kk}(1,6);
    end
    candidates  = find(start_frames-end_frame <= gap_width & start_frames-end_frame > 0);
    if any(candidates)
        % now look for the distance
        posCand = [];
        for no = candidates, posCand = [posCand ; trajs{no}(1,12:14)]; end
        d3d = distance3d(posCand, trajs{k}(end,12:14) );
        
        winner = find(d3d<dist_allowed);
        
        
        if numel(winner)==1
            trajs{k} = [ trajs{k} ; trajs{candidates(winner)}]; 
            trajs{candidates(winner)} = zeros(1,14);
            disp('Connection!');
        elseif numel(winner)>1
            error('multiple winners found');
        end
            
    end
end



end

