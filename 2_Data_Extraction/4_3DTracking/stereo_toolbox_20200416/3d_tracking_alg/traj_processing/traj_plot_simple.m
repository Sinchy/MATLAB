function [] = traj_plot_simple(trajectory_dataset)
% this function shows a simple 3D plot of the trajectories

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

%% prepare plot_matrices

% find longest trajectory
len = [];
for k = 1:size(trajectory_dataset,2)
        len(k) = size(trajectory_dataset{k},1);
end

% initialize trajectory storage matrix
plot_matX = zeros(max(len),size(trajectory_dataset,2));
plot_matY = zeros(max(len),size(trajectory_dataset,2));
plot_matZ = zeros(max(len),size(trajectory_dataset,2));


%% fill plot matrices with trajectory data
for k = 1:size(trajectory_dataset,2)
    traj_cur = trajectory_dataset{k};
    sz = size(traj_cur,1);
    plot_matX(1:sz,k) = traj_cur(:,12);
    plot_matY(1:sz,k) = traj_cur(:,13);
    plot_matZ(1:sz,k) = traj_cur(:,14);
end

% replace zeros by NaN

plot_matX(plot_matX==0) = NaN;
plot_matX(plot_matY==0) = NaN;
plot_matX(plot_matZ==0) = NaN;

%% plot data
figure; hold on;
grid on; box on; view(20,15); 
set(gca, 'linewidth', 1.5, 'fontsize', 18);
xlabel('x (mm)'); ylabel('y (mm)'); zlabel('z (mm)'); 
plot3(plot_matX,plot_matY,plot_matZ);
axis tight
axis equal
