%% create trajectoris from 3d particle positions

tracking_params.maxInvisible = 0;
tracking_params.maxCost = 0.2; % max euclidean 3d-distance from predicted position to detected position
tracking_params.startFrame = 31;
tracking_params.endFrame = 100;

% See documentation of "configureKalmanFilter" for the following parameters:
tracking_params.InitialEstimateError = [1 1 2]; % LocationVariance/VelocityVariance
tracking_params.MotionNoise = [1 1 2]; % LocationVariance/VelocityVariance
tracking_params.Model       = 'ConstantAcceleration';
tracking_params.MeasurementNoise = 1; 
tracking_params.doRangeSearch = 0;  % works also with large particle numbers!
tracks = track_particles('./coords3d/clustered/coords3d_%05d.dat', tracking_params);


%traj_plot_simple(convertToTraj(tracks));