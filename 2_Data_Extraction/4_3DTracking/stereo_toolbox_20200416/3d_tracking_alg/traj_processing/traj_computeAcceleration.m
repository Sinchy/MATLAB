function [ tracks_with_acceleration ] = traj_computeAcceleration( tracks, fps, doFilter )
% Syntax: [ tracks_with_acceleration ] = traj_computeAcceleration( tracks, fps, doFilter )
%This function computes the acceleration of the trajectories and appends it
%to the usual tracks-style input.
% inputs: 
%   -model: 'savitzky-golay' filtering is used before ech diff-stepp

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

for k = 1:length(tracks)
    traj = tracks{k}; % temporary track
    
    traj = traj(:,1:14);
    % process the current temporary track:
    switch doFilter
        case 'savitzky-golay'
            % get positions and filter
            x_sg = sgolayfilt(traj(:,12),2,9);
            y_sg = sgolayfilt(traj(:,13),2,9);
            z_sg = sgolayfilt(traj(:,14),2,9);
            % compute velocities and filter
            vx_sg = diff(x_sg).*fps;
            vy_sg = diff(y_sg).*fps;
            vz_sg = diff(z_sg).*fps;
%             vx_sg = sgolayfilt(diff(x_sg).*fps, 2, 7);
%             vy_sg = sgolayfilt(diff(y_sg).*fps, 2, 7);
%             vz_sg = sgolayfilt(diff(z_sg).*fps, 2, 7);
            % compute accelerations and filter
            ax_sg = sgolayfilt(diff(vx_sg).*fps, 2, 7);
            ay_sg = sgolayfilt(diff(vy_sg).*fps, 2, 7);
            az_sg = sgolayfilt(diff(vz_sg).*fps, 2, 7);
        case 0
            % get positions and filter
            x_sg = traj(:,12);
            y_sg = traj(:,13);
            z_sg = traj(:,14);
            % compute velocities and filter
            vx_sg = diff(x_sg).*fps;
            vy_sg = diff(y_sg).*fps;
            vz_sg = diff(z_sg).*fps;
            % compute accelerations and filter
            ax_sg = diff(vx_sg).*fps;
            ay_sg = diff(vy_sg).*fps;
            az_sg = diff(vz_sg).*fps;
        otherwise
            error('No proper filter given. Incorrect third input parameter.');
    end
    tracks_with_acceleration{k} = [traj , [vx_sg ; NaN], [vy_sg ; NaN], [vz_sg; NaN], padarray(ax_sg,1,NaN), padarray(ay_sg,1, NaN), padarray(az_sg,1, NaN) ];
end


end

