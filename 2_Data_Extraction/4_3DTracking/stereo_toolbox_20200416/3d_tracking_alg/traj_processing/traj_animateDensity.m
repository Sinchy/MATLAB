function [ mov ] = traj_animateDensity( tracks, frames, dens_grid, volume, fileName )
% outputs a video that shows density isosurfaces.
%
%     inputs:
%         - tracks: trajectories obtained from dag-algorithm
%         - frames: frame range, e.g. [1000 2000]
%         - grid:   parameter for density-grid (see traj_getDensity)
%         - volume: parameter for computed volume-range (see traj_getDensity)
%         - fileName:          output video-file name
%
%      outputs:
%         - mov:  matlab VideoWriter movie structure

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

freq = 8.1;


% initialize video-file
mov = VideoWriter(sprintf('freq_%d.avi',freq),'Motion JPEG AVI');
mov.FrameRate = 25;
open(mov);




fig = figure('Position', [50 50 1280 1024], 'PaperPositionMode','Auto');
axis equal;
%opengl('software');
set(gcf,'Renderer','opengl');
resolution=300;
title(sprintf('Frame No.: %04d', 0));
set(gcf,'paperunits','centimeters');
set(gcf,'paperposition',[0 0 1280 1024]./resolution);
% setup the data points to density values
[ ~ , nx, ny, nz ]  = traj_getDensity(zeros(3,3), volume, dens_grid); % use dummy values for positions




% compute all density arrays and sg-filter them
fprintf(1,'Smoothing density data in time...');
for frame = frames(1) : frames(2)
    %positions = traj_getPositionsByFrame(tracks, frame);
    positions = traj_getPositionsStroboscope(tracks, freq, 180, frame);
    densities_all(:,:,:,frame) = traj_getDensity(positions, volume, dens_grid);
end
%densities_smooth = sgolayfilt(densities_all,2,15,[],4);
densities_smooth = densities_all;
fprintf(1,' [done]\n');



for frame = frames(1) : frames(2)
    % get particle positions:
    %positions = traj_getPositionsByFrame(tracks, frame);
    positions = traj_getPositionsStroboscope(tracks, freq, 180, frame);
    % get Density matrix:
    %density   = traj_getDensity(positions, volume, dens_grid);
    
    LEVELS = [3 8 15 20];
    TRANSP = [0.1 0.15 0.2 0.25];
    cmap = colormap(jet(length(LEVELS)));
    for j=1:length(LEVELS)
        lev=LEVELS(j);
        fv = isosurface(nx,ny,nz, densities_smooth(:,:,:,frame), lev);
        patch(fv, 'facealpha', TRANSP(j), 'edgecolor', 'none', 'facecolor', cmap(lev==LEVELS,:));
    end;
    hold on
    plot3(positions(:,1), positions(:,2), positions(:,3), '.b');
    hold off
    %view(100+100*frame/frames(1),10); box on; grid on;
    view(100,0);
    xlabel('y (mm)'); ylabel('x (mm)'); zlabel('z(mm)');
    set(gca,'linewidth',1,'fontsize',16)
    xlim([-5 5]);
    ylim([-5 5]);
    zlim([-4 3]);
    title(sprintf('Frame No.: %04d', frame));
    f = getframe(gcf);
    clf(fig, 'reset');
    writeVideo(mov, f);
end


% close the video object
close(mov);
close(gcf);

end


