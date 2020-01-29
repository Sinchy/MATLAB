function [ trajectories_smoothed ] = traj_smoothTrajectories( trajectories, algorithm_no )
% this function applies smoothing filters to the input trajectories.
% following algorithms are possible (decimal numbers):
%   - 1, savitzky-golay (recommended)

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
trajectories_smoothed = trajectories;
too_short = 0;


for k = 1:size(trajectories_smoothed,2)
    switch algorithm_no
        case 1
            try
                trajectories_smoothed{k}(:,12) = sgolayfilt(trajectories_smoothed{k}(:,12), 2, 9);
                trajectories_smoothed{k}(:,13) = sgolayfilt(trajectories_smoothed{k}(:,13), 2, 9);
                trajectories_smoothed{k}(:,14) = sgolayfilt(trajectories_smoothed{k}(:,14), 2, 9);
            catch exception
                if  strcmp( exception.identifier, 'signal:sgolayfilt:InvalidDimensionsTooSmall')
                    too_short = too_short + 1;
                end
            end
        otherwise
            fprintf(1,'Invalid algorithm input. See help.\n');
                    
    end
    

end

    if too_short
        fprintf(1,'There have been %d trajectories too short for filtering.\n',too_short);
    end

end

