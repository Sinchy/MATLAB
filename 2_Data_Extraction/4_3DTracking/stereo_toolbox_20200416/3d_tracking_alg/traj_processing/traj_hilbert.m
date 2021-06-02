function [result_hilbert] = traj_hilbert(tracks,coordinate,doFilter,framerate,width)

% TRAJ_HILBERT creates a Dataset of Hilbert-analyzed trajectories in 
% TRACKS for the coordinate specified in COORDINATE. Allowed values are
% COORDINATE = 1  -> x
% COORDINATE = 2  -> y
% COORDINATE = 3  -> z
% Unless it is specified in the input, the FRAMERATE is set to 180 frames 
% per second by default. DOFILTER delivers the following options:
%
% no specification or doFilter = 0 : no filtering
% doFilter = 1 : moving average filter with a default bandwith of 15.
% doFilter = 2 : simple subtraction of mean coordinate
% Keep in mind that the moving average filter shortens the trajectory for
% WIDTH frames at the beginning and at the end.

%--------------------------------------------------------------------------
%     Copyright (C) 2016 Carsten Killer (killer@physik.uni-greifswald.de)
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

%% Preparation
% set index for chosen coordinate
if coordinate==1
    c=12;
elseif coordinate==2
    c=13;
elseif coordinate==3
    c=14;
elseif coordinate==4 % >3 can only be used when traj_computeAcceleration was carried out
    c=15;
elseif coordinate==5
    c=16;
elseif coordinate==6
    c=17;
elseif coordinate==7
    c=18;
elseif coordinate==8
    c=19;
elseif coordinate==9
    c=20;
else
    disp('Choose proper value for coordinate (1, 2 or 3)');
end
% DEFAULT: do not create zero-mean of time series
if ~exist('doFilter','var'), doFilter = 0; end;
% DEFAULT: Framerate of 180 fps
if ~exist('framerate','var'), framerate = 180; end;
% DEFAULT: bandwidth for moving average filter 
if ~exist('width','var'), width = 17; end;
% allocate cell array for results
result_hilbert=cell(length(tracks),1);


%% remove NaN rows if acceleration is chosen
if coordinate >=4
    for k = 1:length(tracks)
        tracks{k} = tracks{k}(isfinite(tracks{k}(:,c)), :);
    end
end


%% Actual Computation
for i=1:length(tracks)
   
    if doFilter==2;                             % simple subtraction of mean coordinate
        tracks{i}(:,c) = tracks{i}(:,c) - mean(tracks{i}(:,c));
        doFilter=0;
    end

    % do actual analysis
    H = getWaveProperties([tracks{i}(:,6) tracks{i}(:,c)] , doFilter , width);   
    
    H(:,7)=H(:,7)*framerate;                    % for useful unit of frequency
    result_hilbert{i}=H;                        % save this trajectory to array
    
end
