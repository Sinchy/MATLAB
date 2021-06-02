function [v_x, v_y, v_z, bins, x, y, z ] = traj_velDistr(doShow, trajectories, minLen, frame_range, z_range, vel_bins, fps)
% This function computes (and shows) the velocity distribution of
% x-,y-,z-components.
%
% doShow:       set to 0 to supress figure
% trajectories: usual trajectory dataset   
% minLen:       minimum trajectory length
% frame_range:  starting and ending frame to process
% z_range:      only use velocities in given z-range (mm)
% vel_range:    velocity bins to compute the histogram (default: [-30:2:30])
% normFit:      cell array with normfit-results of each distribution
%
% example syntax: 
% [v_x, v_y, v_z, bins, nFit ] = traj_velDistr(1, trajectories, 30, [100 2000], [-10 10], [-25:2:25]);

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
%#ok<*AGROW>

%%%%%%%%%%%%%%%%%%%%%%%%
% plot:
FontSz = 14;
LineWd = 1;
col_gr_1 = [0.0 0.0 0.0];
col_gr_2 = [0.4 0.4 0.4];
col_gr_3 = [0.6 0.6 0.6];

%%%%%%%%%%%%%%%%%%%%%%%%


% initialize outputs
v_x = [];
v_y = [];
v_z = [];
x = [];
y = [];
z = [];
bins = vel_bins;

% check inputs
if nargin <6
    fprintf(1,'Input arguments missing. See function definition below:\n\n');
    eval('help traj_velDistr');
    return;
end


%% call traj_filterLen to cut out short trajectories

trajs = traj_filterLen(trajectories, minLen);

%% get velocities of trajectory
if ~exist('fps','var')
    fps = input('Please enter framerate: ');
end
trajs_a = traj_computeAcceleration(trajs,fps,'savitzky-golay');

%% examine the trajectories with respect to desired frame_range

for k = 1:size(trajs,2)
    traj_cur = trajs_a{k};
    
    % what parts of trajectory are within frame_range?
    valid_range = ismember(traj_cur(:,6) , min(frame_range):max(frame_range));

    if iscolumn(valid_range)
        valid_range = valid_range';
    end
    
    for kk = find(valid_range)
        % get velocities, if within z-range
        if traj_cur(kk,14)>min(z_range) && traj_cur(kk,14)<max(z_range)
            v_x = [ v_x, traj_cur(kk,15)];
            v_y = [ v_y, traj_cur(kk,16)];
            v_z = [ v_z, traj_cur(kk,17)];
            x = [ x , traj_cur(kk,12)];
            y = [ y , traj_cur(kk,13)];
            z = [ z , traj_cur(kk,14)];
        end
    end
        
end


%% plot the histogramm (TODO: gaussFit)

if doShow
    [ Nx ]= hist(v_x,vel_bins);
    [ Ny ]= hist(v_y,vel_bins);
    [ Nz ]= hist(v_z,vel_bins);
    sum(Nz(vel_bins>0))
    sum(Nz(vel_bins<0))
    
    % h_hist = figure; hold on
    figure('Units', 'Centimeters', 'Position', [5 5 15 10]); hold on;
    
    
    % normalize probability to unity:
    Nx = Nx./sum(Nx);
    Ny = Ny./sum(Ny);
    Nz = Nz./sum(Nz);
    
    plot(vel_bins,Nx','^k', 'Color',col_gr_1,'MarkerFaceColor',col_gr_1 );
    plot(vel_bins,Ny','ok', 'Color',col_gr_2,'MarkerFaceColor',col_gr_2 );
    plot(vel_bins,Nz','s','Color',col_gr_3, 'MarkerFaceColor',col_gr_3);
    
    set(gca,'FontSize',FontSz);
    hndx = get(gca,'xlabel');
    set(hndx,'string','velocity (mm/s)','FontSize',FontSz);
    hndy = get(gca,'ylabel');
    set(hndy,'string','f_v(v)','FontSize',FontSz);
    set(gca,'XLim',[min(vel_bins)+5 max(vel_bins)-5 ]);
    legend({'v_x','v_y','v_z'},'Location','NorthEast')
    set(gca,'Units','Centimeters');
    set(gca,'OuterPosition',[0 0 15 10]);
    set(gcf,'PaperPositionMode','auto');
    grid on
    box on
    set(gca,'LooseInset',[0 0 0 0 ])
    hold off
end

%% fit normal distribution
% 
% v_x_bak = v_x;
% v_y_bak = v_y;
% v_z_bak = v_z;
% 
% 
% % cut off the noise at the edges
% %v_x(v_x<min(vel_bins) | v_x>max(vel_bins) | v_x<mean(v_x)-2*std(v_x) | v_x>mean(v_x)+2*std(v_x)) = [];
% %v_y(v_y<min(vel_bins) | v_y>max(vel_bins) | v_y<mean(v_y)-2*std(v_y) | v_y>mean(v_y)+2*std(v_y)) = [];
% %v_z(v_z<min(vel_bins) | v_z>max(vel_bins) | v_z<mean(v_z)-2*std(v_z) | v_z>mean(v_z)+2*std(v_z)) = [];
% 
% 
% %reject possible nans
% v_x(isnan(v_x)) = [];
% v_y(isnan(v_y)) = [];
% v_z(isnan(v_z)) = [];
% 
% % compute fits
% [mu_x , sigma_x] = normfit(v_x);
% [mu_y , sigma_y] = normfit(v_y);
% [mu_z , sigma_z] = normfit(v_z);
% 
% normFit(1).mu = mu_x;
% normFit(1).sigma = sigma_x;
% normFit(2).mu = mu_y;
% normFit(2).sigma = sigma_y;
% normFit(3).mu = mu_z;
% normFit(3).sigma = sigma_z;
% 
% 
% v_x = v_x_bak;
% v_y = v_y_bak;
% v_z = v_z_bak;

