function [ frequency ] = traj_getFrequency(tracks, fps, doShow )
% no explanation so far

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

if nargin <2, doShow=0; end


% smooth trajectories
tsmooth = traj_smoothTrajectories(tracks, 1); %sgolayfilt(.., 2,9)

tsmooth_hilbert = traj_hilbert(tsmooth, 3, 1, fps);

% find min and max frame
frame_edges = traj_getFrameRange(tsmooth);
frame_min = frame_edges(1);
frame_max = frame_edges(2);
fprintf(1,'Found frame-range of %04d to %04d\n', frame_min, frame_max);

frequency = cell(1+frame_max-frame_min , 1);

%examine inst. frequencies per frame
for k = 1:size(tsmooth_hilbert,1)
for kk = 5:size(tsmooth_hilbert{k},1)-5
    frequency{ 1+ (tsmooth_hilbert{k}(kk,1) - frame_min)  } = [frequency{ 1+ (tsmooth_hilbert{k}(kk,1) - frame_min)  } , tsmooth_hilbert{k}(kk,7)];
end
end

% mean entries and set zeros
for k = 1:size(frequency,1)
    if isempty(frequency{k}),
        frequency_plot(k) = 0;
    else
        frequency_plot(k) = mean( frequency{k} );
    end
end

frequency = frequency_plot;

if doShow
    plot(frame_min:frame_max , frequency);
end
fprintf(1,'Instantaneous Frequency was determined to %04.2f(mean)/%04.2f(median) +- %04.2f\n', mean(frequency), median(frequency), std(frequency));
