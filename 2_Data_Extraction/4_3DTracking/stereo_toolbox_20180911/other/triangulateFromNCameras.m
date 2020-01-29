function [ coord3D, repError] = triangulateFromNCameras( parts2d, P , cameraSets)
% This function triangulates pairwise from different sets of cameras and
% takes the mean
%
% cameraSets must be like [1 2 ; 2 3 ; ...]
%
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


% correspondence-data for what camera is present?
for k = 1:length(parts2d)
    cams_active(k) = ~isempty(parts2d{k});
end
cams = find(cams_active);

% Two methods are possible: triangulate with given sets...
if nargin >2
    pairs = cameraSets; 
else
    % ... or generate sets of cameras, so that each camera will be combined once with
    % another one
    A = tril(ones(length(cams)),-1);
    [I, J] = find(A);
    pairs = [I, J];
end

for k = 1:size(pairs,1)
    c1_num = cams(pairs(k,1));
    c2_num = cams(pairs(k,2));
    P1 = P(c1_num).projectionMatrix;
    P2 = P(c2_num).projectionMatrix;
    
    X{k} = triangulateFrom2Cameras(parts2d{c1_num},parts2d{c2_num},...
        P1, P2, getFundamental(P1, P2), 0 );
end

% get the mean position from all triangulations
X_concat = [];
for k = 1:size(pairs,1)
    X_concat = [X_concat ; X{k}'];
end

coord3D = [mean(X_concat(:,1)) mean(X_concat(:,2)) mean(X_concat(:,3)) ];

if nargout>1
    % get the reprojection error vectors to compute disparity map
    for noOfCam = cams
        p_re{noOfCam} = P(noOfCam).projectionMatrix*[coord3D 1]';
        p_re{noOfCam} = p_re{noOfCam}./p_re{noOfCam}(3);

        repError(noOfCam).x = p_re{noOfCam}(1) - parts2d{noOfCam}(1);
        repError(noOfCam).y = p_re{noOfCam}(2) - parts2d{noOfCam}(2);
    end
end

end

