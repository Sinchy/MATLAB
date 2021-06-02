function [ tracks_filtered ] = traj_filterEpiDistance( tracks, P1, P2, P3, max_ep_dist )
% filters for epipolar distance.
%
% syntax : [ tracks_filtered ] = traj_filterEpiDistance( tracks, min_ep_dist )

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
keep = [];

for k = 1:size(tracks,2)
    ep_dist = traj_getEpiDistance(tracks{k},P1,P2,P3);
    if (max_ep_dist > min(mean(ep_dist,1)))
        keep = [keep  k];
    end
end

tracks_filtered = tracks(keep);

end

