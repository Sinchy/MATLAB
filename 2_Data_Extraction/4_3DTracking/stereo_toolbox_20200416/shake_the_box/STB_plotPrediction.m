function [  ] = plotPrediction( tracks )

% plot all tracks in 3d and add predictions:

for k = 1:length(tracks)
   plot3(tracks(k).position(:,1), tracks(k).position(:,2), tracks(k).position(:,3),'-b');
   hold on;
   % save old filterObject
   filtOld = tracks(k).kalFilter;
   prediction = tracks(k).kalFilter.predict;
   plot3(prediction(1), prediction(2), prediction(3),'.r');
   
   % restore Filter to old state and to remove prediction state - otherwise
   % it would change its state on every call of this function.
    tracks(k).kalFilter = filtOld;
end


end

