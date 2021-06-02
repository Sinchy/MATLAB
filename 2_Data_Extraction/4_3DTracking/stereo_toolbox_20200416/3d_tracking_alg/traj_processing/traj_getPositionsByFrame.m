function [ pos, vels ] = traj_getPositionsByFrame( tracks, framesIn )
% outputs all particle positions that exist at the chosen frame
%
% inputs:
%       -tracks:    cell-array of tracks produced by dag-algorithm
%       -frame:     single integer, frame-number
%
% outputs:
%       -pos:       double-array with 3D particle positions (x,y,z)

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

pos = [];
vels = [];

for k = 1:length(tracks)
    try
        for frame=framesIn
            new_pos = tracks{k}(tracks{k}(:,6)==frame,12:14);
            pos = [pos ; new_pos];
            
            if nargout >1
                new_vels = tracks{k}(tracks{k}(:,6)==frame,15:17);
                vels = [vels ; new_vels];
            end
        end
    end
end

end

