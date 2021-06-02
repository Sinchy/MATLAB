function [ v_x, v_y, v_z, x, y, z ] = traj_getPhaseSpace( tracks, fps, doShow, doFilter )
% this function outputs the velocities and corresponding particle positions. 
% 
% Inputs: 
%     -tracks : usual tracks outputted by dag-algorithm
%     -fps :    frames per second
%     -doShow : set to 1 if you want to produce a figure
%     -doFilter : different filter parameters possible

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

if nargin <4 , doFilter = 'none' ; end
if nargin <3 , doShow = 0; end
if nargin <2 , fps=180; end

%% some constants
FontSz = 12;


%% examine the trajectories
x = [];
y = [];
z = [];
v_x = [];
v_y = [];
v_z = [];


for k = 1:size(tracks,2)
    traj_cur = tracks{k};
    for kk = 1: size(traj_cur,1)-1
        % compute velocities, if within z-range
        v_x = [ v_x, (traj_cur(kk+1,12)-traj_cur(kk,12))*fps ];
        v_y = [ v_y, (traj_cur(kk+1,13)-traj_cur(kk,13))*fps ];
        v_z = [ v_z, (traj_cur(kk+1,14)-traj_cur(kk,14))*fps ];
        x = [x, traj_cur(kk,12)];
        y = [y, traj_cur(kk,13)];
        z = [z, traj_cur(kk,14)];
    end
end

%% apply some filters on the data

switch doFilter
    case 'none',
        
end

%% draw a fancy image

if doShow
    figure('Units', 'Centimeters', 'Position', [5 5 15 15]);
    set(gcf,'PaperPositionMode','auto');
    
    subplot(3,1,1);
    plot(x, v_x, '.r', 'MarkerSize', 1);
    set(gca,'FontSize',FontSz);
    hndx = get(gca,'xlabel');
    set(hndx,'string','x (mm)','FontSize',FontSz);
    hndy = get(gca,'ylabel');
    set(hndy,'string','v_x (mm/s)','FontSize',FontSz);
    set(gca,'Units','Centimeters');
    set(gca,'OuterPosition',[0 10 15 5]);
    set(gca,'LooseInset',[0 0 0 0 ])
    
    subplot(3,1,2);
    plot(y, v_y, '.g', 'MarkerSize', 1);
    set(gca,'FontSize',FontSz);
    hndx = get(gca,'xlabel');
    set(hndx,'string','y (mm)','FontSize',FontSz);
    hndy = get(gca,'ylabel');
    set(hndy,'string','v_y (mm/s)','FontSize',FontSz);
    set(gca,'Units','Centimeters');
    set(gca,'OuterPosition',[0 5 15 5]);
    set(gca,'LooseInset',[0 0 0 0 ])
    
    subplot(3,1,3);
    plot(z, v_z, '.b', 'MarkerSize', 1);
    set(gca,'FontSize',FontSz);
    hndx = get(gca,'xlabel');
    set(hndx,'string','z (mm)','FontSize',FontSz);
    hndy = get(gca,'ylabel');
    set(hndy,'string','v_z (mm/s)','FontSize',FontSz);
    set(gca,'Units','Centimeters');
    set(gca,'OuterPosition',[0 0 15 5]);
    set(gca,'LooseInset',[0 0 0 0 ])
    
end





end

