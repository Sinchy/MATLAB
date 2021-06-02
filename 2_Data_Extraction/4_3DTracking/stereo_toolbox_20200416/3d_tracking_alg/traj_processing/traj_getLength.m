function [ len ] = traj_getLength(tracks)
% returns an array containing the length od the trajectories
len = [];

if isstruct(tracks)
    tracks = convertToTraj(tracks);
end

for k = 1:length(tracks)
   len(k) = size(tracks{k}(:,6),1); 
end



end

