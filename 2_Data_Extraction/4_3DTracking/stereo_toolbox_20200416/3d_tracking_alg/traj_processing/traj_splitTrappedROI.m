function [ non_trapped_trajs,  trapped_trajs ] = traj_splitTrappedROI( tracks )
% This function enables the user to select the trapped-roi of a trajectory.
%tracks must already contain the velocity components,
%(traj_ComputeAcceleration)

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

[~, ~, pos_range] = traj_getPosRange(tracks);
non_trapped_trajs = cell(1);
trapped_trajs = cell(1);
h = figure('Units','Pixel','Position',[50 50 500 500]);
AX = gca;

for traj = 1:length(tracks)
    
    y = tracks{traj}(:,14)';
    x = 1:size(y,2);
    plot(AX,x,y); hold on;
    title(sprintf('Trajectory %d/%d',traj,length(tracks)));
    ylim(pos_range);
    set(gca,'Units','Pixel','OuterPosition',[0 0  500 500] ,'LooseInset',[0 0 0 0 ]);
    [X, ~, button] = ginput(2);
    
    if button == 1,
        if floor(min(X))<1, X(X==min(X)) = 1;end
        if ceil(max(X))>size(tracks{traj},1), X(X==max(X)) = size(tracks{traj},1);end
        
        if floor(min(X))>1,
            t_outer_left  = tracks{traj}(1:floor(min(X)), :);
            non_trapped_trajs = [non_trapped_trajs{:} {t_outer_left}];
        end
        
        if ceil(max(X))<size(tracks{traj},1),
            t_outer_right = tracks{traj}(ceil(max(X)):end, :);
            non_trapped_trajs = [non_trapped_trajs{:} {t_outer_right}];
        end
        
        t_inner = tracks{traj}(floor(min(X)):ceil(max(X)),:);
        trapped_trajs     = [trapped_trajs{:} {t_inner}];
    end
    
    hold off;
end
close(h);

end

