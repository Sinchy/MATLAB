function [ C_plot, vel_phase] = traj_forceSpaceTimePlot( tracks , grid_z, vel_phase_bins)
% [  ] = traj_forcePeriodogram( tracks )
% This function plots the acceleration (~force) via imagesc as a z(t) plot
% with the acceleration beeing color-coded.

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

% prepare data
tracks_a = traj_computeAcceleration(tracks, 260, 'savitzky-golay');

% find min and max height
z_min = +inf;
z_max = -inf;
for k = 1:length(tracks_a)
    if min(tracks_a{k}(:,14)) < z_min , z_min = min(tracks_a{k}(:,14)); end
    if max(tracks_a{k}(:,14)) > z_max , z_max = max(tracks_a{k}(:,14)); end
end
fprintf(1,'Found z-range of %0+4.1fmm to %0+4.1fmm\n', z_min, z_max);

% find min and max frame
frame_min = +inf;
frame_max = -inf;
for k = 1:length(tracks_a)
    if min(tracks_a{k}(:,6)) < frame_min , frame_min = min(tracks_a{k}(:,6)); end
    if max(tracks_a{k}(:,6)) > frame_max , frame_max = max(tracks_a{k}(:,6)); end
end
fprintf(1,'Found frame-range of %04d to %04d\n', frame_min, frame_max);


%initialize grid
C = cell(grid_z, 1+frame_max-frame_min);
vel_phase = cell(grid_z,1+frame_max-frame_min); % skip unused rows later...


% put values into grid
for k = 1:length(tracks_a)
for kk = 1:size(tracks_a{k},1)
    % find z-grid location for this value
    [ idx_z, ~] = binData(tracks_a{k}(kk,14), z_min, z_max, grid_z);
    
    % find frame-grid location for this value
    idx_frame = 1+frame_max-tracks_a{k}(kk,6);

    C{idx_z, idx_frame} = [ C{idx_z, idx_frame} , norm( [tracks_a{k}(kk,18) tracks_a{k}(kk,19) tracks_a{k}(kk,20)]) ];
    if ismember(idx_z,vel_phase_bins)
        if numel(idx_z)>1
            error('more than one idx_z. Smething went wrong...');
        end
        vel_phase{idx_z, idx_frame} = [ [vel_phase{idx_z, idx_frame}] ; tracks_a{k}(kk,17)  ];
    end
end
end

C_plot = zeros(size(C));
% compute means in C
for k = 1:size(C,1)
for kk = 1:size(C,2)
    if isempty(C{k, kk})
        C_plot(k, kk) = 0;
    else
        C_plot(k, kk) = nanmedian(C{k, kk});
    end
end
end
%colormap(jet(256));
%figure;
%imagesc(C_plot);


%make double array from vel_phase:



end

