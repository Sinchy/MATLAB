function [ tracks ] = traj_applyRotationTranslation( tracks, rotation, translation )
% applies given rotation and translation to trajectories
if isstruct(tracks)
    tracks = convertToTraj(tracks);
end

for k = 1:length(tracks)
    for kk = 1:size(tracks{k}(:,12),1)
        tracks{k}(kk,12:14) = tracks{k}(kk,12:14)-translation;
         tracks{k}(kk,12:14) = (rotation*tracks{k}(kk,12:14)')';
       % tracks{k}(kk,12:14) = (rotation*(tracks{k}(kk,12:14)-translation)')';
    end
end

end

