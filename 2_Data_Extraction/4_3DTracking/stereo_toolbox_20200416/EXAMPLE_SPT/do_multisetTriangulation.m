%% multiset triangulation
% This script carries out the 3d-particle position estimation. A set of 3
% cameras is chosen from all of the available cameras.

%%  preferences

% define the camera sets to be used
settings.triangulation.sets = [1 2 3 ; 2 3 4 ; 3 4 1 ; 4 1 2 ; 1 3 4 ; 2 4 1];
settings.triangulation.epipolarDistanceAllowed = 1.25;


%% process multiset triangulation
% the scrit will create subfolders named "/cam123 ; /cam234 ..."
settings.output2Dcoords = './coords2d/coords2d_%05d.dat';
settings.output3Dcoords = './coords3d/';
settings.im_range = 31:100;

settings = nCam3dMultiset( settings, cameraSystem, 1, 0 );



%% refine using clustering
frameToProcess = 31:100;
visInNumofPerms = 2;
clusterSizeApprox = 0.05;
doShow = 0;
writeToDisk = 1;
triangulationToCluster(settings, frameToProcess, visInNumofPerms, clusterSizeApprox, doShow, writeToDisk);
