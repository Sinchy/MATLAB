function [ pos3d ] = tomo_getParticlePositions( basisFunction, X, Y, Z, threshold, cutOffDist )
% This function looks for clusters using a given threshold

%% find the clusters
voxAboveThresh = basisFunction > threshold;

% error if too many elements are given back
if nnz(voxAboveThresh) > 0.01*numel(basisFunction)
    error('Maybe too many elements returned.');
end

% find clusters
% compute distance matrix, euclidean metric
positions = [X(voxAboveThresh), Y(voxAboveThresh), Z(voxAboveThresh)];
if isempty(positions)
    pos3d = [];
    return;
end
intensities = basisFunction(voxAboveThresh);
dist = pdist(positions,'euclid');
link = linkage(dist, 'single'); % the distance type may be varried...
clusteredIdx = cluster(link, 'cutoff', cutOffDist, 'criterion', 'distance');



%% determine position using weighted center of mass. The weights are the intensities of the basisFunctions
clusterNums = unique(clusteredIdx(:,1));

for k = reshape(clusterNums,1, [])
    idx = find(clusteredIdx == k);
    thisCluster     = positions(idx,:);
    thisIntensities = ones(size(thisCluster,1),3).*intensities(idx);
    pos3d(k,:) = 1./sum(thisIntensities,1) .* sum(thisIntensities.*thisCluster,1);
end

