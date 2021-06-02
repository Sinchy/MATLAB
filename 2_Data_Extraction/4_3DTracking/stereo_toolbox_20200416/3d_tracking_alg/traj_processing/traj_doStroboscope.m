function [ tracks_strobo ] = traj_doStroboscope( tracks, frequency, fps )
% Usage: [ tracks_strobo ] = traj_doStroboscope( tracks, frequency, fps )
% This function changes the frame-value of each particle position into the
% first period of an oscillation.
% 
% Inputs:
%     - tracks: as usual... 
%     - frequency  : frequency of wave (i.e. obtained by traj_getFrequency)
%     - fps        : recording framerate
%     - frame_range: the min and max frame to be processed e.g. [1500 2000]
% Outputs:
%     - tracks_strobo: original tracks with CHANGED frame-values

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
[frame_min_max] = traj_getFrameRange(tracks);
frame_min = frame_min_max(1);

for k = 1:length(tracks)
    for kk = 1:size(tracks{k},1)
        % map the frame back to first period
        frame_strobo = 1+round(mod((tracks{k}(kk,6)-frame_min) , (fps/frequency)));
        tracks{k}(kk,6) = frame_strobo;
    end
end
tracks_strobo = tracks;


end
