%% create trajectoris from 3d particle positions

tracking_params.maxInvisible = 2;
tracking_params.maxCost = 0.2; % max euclidean 3d-distance from predicted position to detected position
tracking_params.startFrame = 1;
tracking_params.endFrame = 200;

% See documentation of "configureKalmanFilter" for the following parameters:
tracking_params.InitialEstimateError = [1 1 2]; % LocationVariance/VelocityVariance
tracking_params.MotionNoise = [1 1 2]; % LocationVariance/VelocityVariance
tracking_params.Model       = 'ConstantAcceleration';
tracking_params.MeasurementNoise = 1; 
tracks = track_particles('./coords3d_%05d.dat', tracking_params);


%traj_plot_simple(convertToTraj(tracks));