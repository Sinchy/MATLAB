function [ clusteredData ] = clusterFromMultiset( nonClusteredData, cutOffDist )
% This function uses the matlab-internal clustering methods to analyse the
% datasets created by triangulation from different camera permutations.
% This function is called by triangulationToCluster.m
%
% keywords: hirarchical clustering, cluster, pdist, linkage
% The data must me an mx3-array, where m is the particle numbering and 3
% columns are the x, y and z-component in real world.
%
% implemented by: M. Himpel, 2016-07-29

% compute distance matrix, euclidean metric
%dist = pdist(nonClusteredData,'euclid');

%link = linkage(dist, 'centroid', 'savememory', 'on'); % the distance type may be varried...
link = linkage(nonClusteredData, 'ward','euclidean', 'savememory', 'on'); % the distance type may be varried...

clusteredIdx = cluster(link, 'cutoff', cutOffDist, 'criterion', 'distance');

clusteredData = [clusteredIdx, nonClusteredData];

end

