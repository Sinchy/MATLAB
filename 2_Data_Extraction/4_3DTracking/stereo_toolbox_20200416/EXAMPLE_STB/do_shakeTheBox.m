% This algorithm is an implementation of the "Shake-the-box"-algorithm
% described by D. Schanz and F. Wienecke.

% The algorithm loads a bunch of pre-analyzed tracks. As a starting point,
% one needs trajectories that can be used to predict the position in the
% upcoming frame. The prediction is then corrected/optimized to fit the
% measurement images

%% preparation

% shake-the-box parameters
STB_params.normalShakeWidth = 10e-3;  %mm in 3d-space
STB_params.nCameras         = 4;
STB_params.evalWindowSize   = 4; %px
STB_params.particleSize     = 4;  %px
STB_params.projection.width = 4;  %px
STB_params.detect2d.threshold = [0.3 0.3 0.3 0.3]; % intensity 0...1
STB_params.detect2d.lObject = [7 7 7 7];  %px
STB_params.detect2d.lNoise = [3 3 3 3];  %px
STB_params.detect2d.output2dFilemask = './coords2d/coords2d_%05d.dat';
STB_params.imagePaths = './cam%d/image_%05d.png';
STB_params.processedDataOutput = './coords3d/stb_coords3d_%05d.dat';
STB_params.newTrackDistanceAllowed = 0.05; % (mm)
STB_params.verboseMode = 0;
STB_params.lowerIntensityThreshold = [0.075 0.075 0.05 0.05]; % camera-wise

% correspondence analysis (used after each shaking converged)
STB_params.detect2d.threshold = [2, 2, 1.5, 1.5]; % intensity 0...1
STB_params.triangulation.output3Dcoords = './coords3d/';
STB_params.output3Dcoords = STB_params.triangulation.output3Dcoords;
STB_params.triangulation.sets = [1 2 3 ; 2 3 4; 3 4 1; 4 1 2 ];
STB_params.output2Dcoords = STB_params.detect2d.output2dFilemask;
STB_params.triangulation.epipolarDistanceAllowed = 1.5;
STB_params.triangulation.visInNumofPerms   =  3    ;   % in how many sets, the particle must be detected?
STB_params.triangulation.clusterSizeApprox =  0.003;   % dia of spatial sphere, where particles are grouped
STB_params.triangulation.notAllowedInProximity = 0.03 ;

% configure the kalman filter that is used to predict new positions of
% tracked particles
STB_params.kalmanFilter.Model                  =  'ConstantVelocity';
STB_params.kalmanFilter.InitialEstimateError   =  [0.5 0.5] ; % LocationVariance/VelocityVariance
STB_params.kalmanFilter.MotionNoise            =  [0.1 0.1 ]; % LocationVariance/VelocityVariance
STB_params.kalmanFilter.MeasurementNoise       =  1e-4;

% main processing parameters
framesToProcess = 41:141;
maxShakingIter  = 40;
maxReTriangulationIterCntr = 2; % only two allowed at the moment!

%% load and prepare pre-analyzed tracks
% pre-initialized tracks have to be given that cover enough of the given
% particles for at least ??? frames to allow the STB-algorithm to converge
% by loading the given tracks, the kalman-filter "learns" about the motion
% parameters of the particles. This gives the possibility for predictions!
[ tracks,  discontinuedTracks, triangPredictions] = loadInitialTracks( initTracks, STB_params, cameraSystem );

%% main loop
%cycle trough all frames
for frameCntr = framesToProcess
    
    % load the camera images. Some processing is done here according to
    % given STB_params (blur, sobel, ROI, ...)
    I = STB_loadCameraImages(STB_params, frameCntr);
    
    % if two triangulated points from the last 2 frames (now-1 and now) are close to eachother, generate
    % a new track from them and make a prediction
    tracks = STB_handleNewTracks( tracks, frameCntr, STB_params );
    
    % use the information of the Kalman-Filter and the former intensities
    % to predict the next particle position and it's intensity
    [ predictions, intensities, tracks ] = STB_predictFromTracks( tracks );
    
    % start the newly opened frame with the predicted positions
    tracks = STB_prepareShake(tracks, predictions, intensities);
    
    % if demanded, update the trajectory plot, or comment out
    [tracks] = STB_updateTrajectoryPlot(tracks);drawnow;
    
       
    fprintf(1,'STB:: frame: %04d ',frameCntr);
    
    %"retriangulation" means, that after the shaking-run completed
    %(particle predictions could be matched with the image or not),
    %triangulation is done to find more/new particles in the field-ov-view.
    %The particles that have already been identified are erased from the
    %measurement images before the triangulation starts. Ideally, after
    %sufficient "retriangulations", the measurement image contains no
    %particles anymore.
    for reTriangulationIterCntr = 1:maxReTriangulationIterCntr
        fprintf(1,'pass: %02d: ',reTriangulationIterCntr);
        
        if reTriangulationIterCntr > 1
            % add the (partially yet unconverged) triangPositions
            tracks = [tracks, triangPredictions ];
            triangPredictions(:) = [];  % empty the struct for the next execution
        end
        
        for shakingIterCntr = 1:maxShakingIter
            fprintf(1,'shake: %02d: ',shakingIterCntr);
            fprintf(1,'%05d/%05d converged.',length(find([tracks.converged])) , size(tracks,2) );
            
            if ~( length(find([tracks.converged])) == size(tracks,2) )
                % TODO: initial shake with larger shift??
                
                % shake it!
                [ tracks ] = STB_normalShake( STB_params, cameraSystem, tracks, I );
                
                % decide if intensity falls below a certain threshold and delete the particle
                [ tracks, discontinuedTracks ] = STB_sortOutIntensity(tracks, discontinuedTracks, STB_params);
            end
            
            if (shakingIterCntr ~= maxShakingIter)
                fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b');
                fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
            end
        end
        
        % if triang should be done, find new particles in residual images:
        if reTriangulationIterCntr < maxReTriangulationIterCntr
            fprintf(1,'\n');
     
            % replace current image with residual image (delete the
            % converged particles)
            I = STB_getResidualImage(STB_params, cameraSystem, STB_get3DPositions(tracks([tracks(:).converged]) ), STB_getIntensities(tracks([tracks.converged]) ), I);
            
            % find particles in residual image
            [ triangPredictionsArray ] = STB_triangulateResidualParticles(I, cameraSystem, STB_params, frameCntr);
            
            % store the results in the predictions-struct. The 3d location and
            % the frame-information will be stored.
            [ triangPredictions ] = STB_updateTriangPredictions(triangPredictions, triangPredictionsArray, tracks, STB_params, frameCntr);
        end
        fprintf(1,'\b\b\b\b\b\b\b\b\b\b');
    end
    
    % Handle continuation of tracks, discontinue others and
    % correct the predictions.
    tracks = STB_correctPositions ( tracks );
    [ discontinuedTracks, tracks ] = STB_discontinueTracks( discontinuedTracks, tracks );
    
    
    
    % writing particle positions (and intensities for further analysis) to
    % disk
    [path, ~,~] = fileparts(STB_params.processedDataOutput);
    if ~exist(path, 'dir')
        mkdir(path);
    end
    dlmwrite(sprintf(STB_params.processedDataOutput, frameCntr), horzcat( STB_get3DPositions(tracks([tracks(:).converged])), STB_getIntensities(tracks([tracks.converged])) ) );
    
    fprintf(1,'\b\b\b\b [ done ]\n');
end