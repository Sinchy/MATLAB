function [ positions ] = traj_getPositionsStroboscope( tracks, frequency, fps,  frame )
% maps particle positions of all tracks onto the first wave period. Be sure
% to cut of the desired frames defore input of "tracks".

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

% compute period-grid:
frame_length = floor(1/frequency)*fps ;
if frame_length>frame
    error('Querried frame outside of first wave period!');
end

% initialize empty output array
positions = [];

% find frames that belong to the querried bin
for k = 1:length(tracks)
    % algorithm to bin the data. This is critical an could be improved.
    idx_qBin = mod(tracks{k}(:,6),(1/frequency)*fps);
    idx_qBin = find( abs(idx_qBin-frame)<0.5 );
    positions = [ positions ; tracks{k}(idx_qBin,12:14) ];
end




end

