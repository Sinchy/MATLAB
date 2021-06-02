function [ ep_dist ] = traj_getEpiDistance( track, P1, P2, P3 )
% This function computes the epipolar distances of every point of a given
% trajectory.
% Syntax: [ ep_dist ] = traj_getEpiDistance( track, P1, P2, P3 )

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

% one cannot know what cameras are used to compute the correspondence. So
% we give the dinstances in all three combinations

F12 = getFundamental(P1, P2);
F13 = getFundamental(P1, P3);
F23 = getFundamental(P2, P3);
ep_dist = [];

for k = 1:size(track,1)
    % columns are Cam: 1-2 / 1-3 / 2-3
    
    
    [l1, ~] = projectRay(P2, P1, track(k,1:2), F12);
    ep_dist(k,1) = dist2line2d(track(k,3:4), l1);
    
    [l2, ~] = projectRay(P3, P1, track(k,1:2), F13);
    ep_dist(k,2) = dist2line2d(track(k,3:4), l2);
    
    [l3, ~] = projectRay(P3, P2, track(k,1:2), F23);
    ep_dist(k,3) = dist2line2d(track(k,3:4), l3);
end


end

