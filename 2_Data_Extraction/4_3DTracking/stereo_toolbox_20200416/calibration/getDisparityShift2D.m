function [ disparityShift ] = getDisparityShift2D( disparityMap, checkIndXY )
% This function needs the disparity map as an input and looks for local
% maxima in each subMap. Optional but recommended is to give alist of
% indices of the subimages to check. Mostly, the disparity vecor in the
% outer regions of a camera image is erroneous due to many
% non-corresponding particles observed there.
%
% INPUTS:
%       disparityMap: produced by getDisparityMap2D
%       checkIndXY:   a list of indices pointing to the desired subMaps
%                     e.g. [2 3 ; 3 3 ; 2 4 ; 3 4]
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
%% initialization
numOfSubs = size(checkIndXY,1);
H = fspecial('gaussian',round(size(disparityMap,3)/2),5);

%% processing
collectSubs = zeros(size(disparityMap,3), size(disparityMap,4));

for k = 1:numOfSubs
    subMap = squeeze(disparityMap(checkIndXY(k,1),checkIndXY(k,2), : , : )) ;
    subMap(isnan(subMap)) = 0;
    tempMap = zeros(size(disparityMap,3), size(disparityMap,4));
    tempMap(subMap == max(subMap(:))) = 1;
    tempMap = imfilter(double(tempMap),H);
    collectSubs = tempMap + collectSubs;
end

% find the strongest maximum of the resulting BWimage
positionInd = find(collectSubs == max(collectSubs(:)));
[indY, indX] = ind2sub(size(collectSubs),positionInd);

centerOfSubMap = [ (size(disparityMap,4)+1)/2 , (size(disparityMap,3)+1)/2 ];
disparityShift = ([indX(1), indY(1)] - centerOfSubMap )./10; % to give the value in image pixels rather than subimage-pixels

end

