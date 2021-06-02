% This script helps you to refine the calibration or to adopt it to a
% slightly translated camera system.
%
% The algorithm is as follows: The disparities of all reprojections are
% plotted as gaussian blobs in sub-images. The peak of the resulting blob indicates the
% shift of the certain camera. This shift will be subtracted from the
% camera's principal point and the algorithm iterates until the shift is small enough.


%% preferences

% The subMap-resolution has to include the largest shift. The real
% disparity in pixels is multiplied by 10 to increase the accuracy. So, if
% you consider a shift of <=5px, go for >50px of subRes.
settings.disparityRefinement.subRes = 150; % resolution of sub maps

% The number of cells, for the images to be converted into. Choose the cell
% number (respectively, its size) so that you have some cells in which the
% number of detected disparitys is sufficient to give good statistics.
settings.disparityRefinement.Nx = 10; % no of maps in x
settings.disparityRefinement.Ny = 10; % no of maps in y

% Which of the cells should be considered? The cells especially in the
% outer regions of the image give poor detected image data. Give the
% desired cells in [Nx1, Ny1 ; Nx2, Ny2 ; ...] format.
settings.disparityRefinement.cellsCam{1} = [4 5 ; 4 6 ; 5 5 ; 5 6]; % [] ...shows all cells...
settings.disparityRefinement.cellsCam{2} = [5 5 ; 5 6 ];
settings.disparityRefinement.cellsCam{3} = [5 5 ; 5 6 ];
%settings.disparityRefinement.cellsCam{4} = [];

% frames to be processed (more for robuster statistics):
settings.disparityRefinement.frameRange = 1:19;

% load the cameraSystem-object before start (will be called in the
% iteration-section)

% numbers of iteration, usually, 2 or 3 are enough
numsOfIteration = 1;

% give the 3D coordinates path, that shall be used.
settings.output3Dcoords = './EXAMPLE/Coords3d/';
settings.output2Dcoords = './EXAMPLE/Coords2d/coords_2d_%05d.dat';

% initial maximum epipolar distance allowed
settings.triangulation.sets = [1 2 3 ];
settings.triangulation.epipolarDistanceAllowed = 5;

% graphical output trigger
doShow = 1;

%% OPTIONAL RESET OF CAMERASYSTEM
cameraSystem.resetPP; % to start at the unaltered state of the calibration


%% process iteration
for k = 1:numsOfIteration
    fprintf(1,'Determining disparity map:: Starting new iteration...\n');
    settings.im_range = settings.disparityRefinement.frameRange;  % process the desired frames
    
    % Now make correspondence analysis and triangulate. The results will be
    % output to "settings.output3Dcoords"/camxyz/coords3d_%05d.dat
    settings = nCam3dMultiset( settings, cameraSystem, 1, 0 );
    
    
    % Now, there exist files containing many wrong (including the correct)
    % correspondences. The disparity map can reveal the shift of the camera
    % system so that the wrong correspondences can be eliminated by
    % reducing the epipolar distance.
    [~, dispMap] = getDisparityMap2D(cameraSystem, settings);
    for noOfCam = 1:cameraSystem.nCameras
        shift        = getDisparityShift2D(dispMap{noOfCam}, settings.disparityRefinement.cellsCam{noOfCam} );
        
        fprintf(1,'Iteration %d::Estimated Shift of Cam%d %05.1f %05.1f \n',k, noOfCam, shift(1),shift(2));
        
        cameraSystem.setPPshift(shift, noOfCam);
        
        if doShow
            plotDisparityMap2D(dispMap{noOfCam},  settings.disparityRefinement.cellsCam{noOfCam});
            title(sprintf('Camera %d - iteration %d',noOfCam, k));
            drawnow
        end
    end
end

fprintf(1,'The camera-system object in your workspace has been altered.\nSave it or discard the changes by calling "cameraSystem.resetPP"\n');
