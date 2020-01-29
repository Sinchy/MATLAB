function [ tracks ] = STB_prepareShake( tracks, predictions, intensities )
% empty the converged-field

for k = 1:length( tracks)
    tracks(k).converged = false;
    tracks(k).position(end+1, :) = predictions(k, :);
    tracks(k).intensities(end+1, :) = intensities(k, :);
    tracks(k).frames(end+1) = tracks(k).frames(end)+1;
    tracks(k).predictions(end+1,:) = predictions(k, :);
end

