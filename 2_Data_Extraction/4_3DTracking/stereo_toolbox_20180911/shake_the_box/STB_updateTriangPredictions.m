function [ triangPredictions ] = STB_updateTriangPredictions(triangPredictions, triangPredictionsArray, tracks, STB_params, frameCntr)
% This function updates the predictions-struct. It just appends newly found
% 3d-positions, that are candidates of particles. If a new track will be
% generated from these particles will be decided later from
% STB_beginNewTrack.m .

meanIntensity = mean( STB_getIntensities(tracks),1);

%  exclude triangulated positions that are too close to existing particles
%  in the current track
existingPositions = STB_get3DPositions(tracks);

triangTooClose = zeros(size(triangPredictionsArray,1),1);
for k = 1:size(triangPredictionsArray,1)
    dist = distance3d(existingPositions, triangPredictionsArray(k,:));
    if any(dist<STB_params.triangulation.notAllowedInProximity)
        triangTooClose(k) = 1;
    end
end
keepPreds = ~logical(triangTooClose);

triangPredictionsArray = triangPredictionsArray(keepPreds,:);

for k = 1:size(triangPredictionsArray,1)
    % generate new index (end+1) and store the info
    triangPredictions(end+1).position = triangPredictionsArray(k, 1:3);
    triangPredictions(end  ).frames   = frameCntr;
    triangPredictions(end  ).converged= false;
    triangPredictions(end  ).intensities = meanIntensity;
    
    % initialize kalman-filter
    kalmanFilter = configureKalmanFilter(STB_params.kalmanFilter.Model, ...
        triangPredictionsArray(k, 1:3), STB_params.kalmanFilter.InitialEstimateError, STB_params.kalmanFilter.MotionNoise, STB_params.kalmanFilter.MeasurementNoise);
    triangPredictions(end  ).kalFilter = kalmanFilter;
end

end

