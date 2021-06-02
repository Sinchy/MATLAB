function [ x_range, y_range, z_range ] = traj_getPosRange( tracks )
% [ x_range, y_range, z_range ] = traj_getPosRange( tracks )
% This function returns the minimum and maximum extensions of tracks.

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

% find min and max height
x_min = +inf;
x_max = -inf;
for k = 1:length(tracks)
    if min(tracks{k}(:,12)) < x_min , x_min = min(tracks{k}(:,12)); end
    if max(tracks{k}(:,12)) > x_max , x_max = max(tracks{k}(:,12)); end
end
fprintf(1,'Found x-range of %0+5.2fmm to %0+5.2fmm\n', x_min, x_max);


% find min and max height
y_min = +inf;
y_max = -inf;
for k = 1:length(tracks)
    if min(tracks{k}(:,13)) < y_min , y_min = min(tracks{k}(:,13)); end
    if max(tracks{k}(:,13)) > y_max , y_max = max(tracks{k}(:,13)); end
end
fprintf(1,'Found y-range of %0+5.2fmm to %0+5.2fmm\n', y_min, y_max);



% find min and max height
z_min = +inf;
z_max = -inf;
for k = 1:length(tracks)
    if min(tracks{k}(:,14)) < z_min , z_min = min(tracks{k}(:,14)); end
    if max(tracks{k}(:,14)) > z_max , z_max = max(tracks{k}(:,14)); end
end
fprintf(1,'Found z-range of %0+5.2fmm to %0+5.2fmm\n', z_min, z_max);


x_range = [x_min x_max];
y_range = [y_min y_max];
z_range = [z_min z_max];

end

