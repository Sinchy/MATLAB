function [ prediction, intensities, tracks ] = STB_predictFromTracks( tracks )
% This function gets the already tracked particles as an input and uses the
% Kalman-Filter to estimate the particle's following 3D-position.
% The intensity information throughout the track is also used to
% extrapolate to the following particle intensity.


fprintf(1,'STB:: Predict Position and Intensity...');
% pre-allocate arrays
prediction  = zeros(length(tracks) , 3);
intensities = zeros(length(tracks) , 4);

for k = 1:length(tracks) % cycle through all given particles
    % by calling "predict", the state of the Kalman-Filter changes
    % permanently. Don't call this method again until the "correct"-method
    % has been called.
    prediction (k, :) = tracks(k).kalFilter.predict;      % predict method of filter-object
    intensities(k, :) = mean( tracks(k).intensities, 1 ); % get mean for every column
end

fprintf(1,' [ done ]\n');
end

