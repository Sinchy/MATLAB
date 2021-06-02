function  showSubpixelMap( settings, frame )
% This functions shows the subpixelmap of all available cameras in the
% desired frame range (or frame).
% INPUTS:
%           settings - settings-structure from stereo-toolbox
%           frame    - scalar or array of numbers to use the detected
%                      particles from
%
% Interpretation: Uniform distribution of the subpixel values indicate the
% absence of pixel-locking, whereas groups of points indicate pixel-lockign
% effects.

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

% get the particle positions
particle_pos = [];

for k = frame
particle_pos = [ particle_pos ; dlmread(sprintf(settings.output2Dcoords,k))];
end

% separate by coordinates and erase zero entries
cam1_pos = particle_pos(find(particle_pos(:,1)),1:2);
cam2_pos = particle_pos(find(particle_pos(:,3)),3:4);
cam3_pos = particle_pos(find(particle_pos(:,5)),5:6);

% convert all entries to subpixel values
cam1_pos = cam1_pos - floor(cam1_pos);
cam2_pos = cam2_pos - floor(cam2_pos);
cam3_pos = cam3_pos - floor(cam3_pos);

% plot the subpixel map
figure('Name','Sub-Pixel Maps');
title('Uniform point distribution indicates the absence of pixel locking')
subplot(1,3,1);
plot(cam1_pos(:,1),cam1_pos(:,2),'b.');axis equal
xlim([0 1])
ylim([0 1])
title('Camera 1')
subplot(1,3,2);
plot(cam2_pos(:,1),cam2_pos(:,2),'b.');axis equal
xlim([0 1])
ylim([0 1])
title('Camera 2')
subplot(1,3,3);
plot(cam3_pos(:,1),cam3_pos(:,2),'b.');axis equal
xlim([0 1])
ylim([0 1])
title('Camera 3')
