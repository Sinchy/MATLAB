function [ fractionFound, errParticleFraction ] = compare3Dpositions(groundTruth , testData, allowedDeviation)
% This functions compares two given *.dat-files or arrays. It looks for
% found 3D-positions and outputs an absolute value for the fraction found.

for k = 1:size(groundTruth,1)
    dist = distance3d(testData, groundTruth(k,:));
    found(k) = any(dist<allowedDeviation);
end
    
fractionFound = numel(find(found)) ./ size(groundTruth,1);
errParticleFraction = ( size(testData,1)-numel(find(found)) ) / size(groundTruth,1);


end

