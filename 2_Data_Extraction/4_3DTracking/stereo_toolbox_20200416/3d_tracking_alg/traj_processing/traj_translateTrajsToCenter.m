function [ trajectories ] = traj_translateTrajsToCenter(trajectories)

fprintf(1,'Getting mean of positions...');
if isstruct(trajectories)
    trajs = convertToTraj(trajectories);
else
    trajs = trajectories;
end

frameRange = traj_getFrameRange(trajs);
idx = 0;

for k = frameRange(1):frameRange(2)
    idx = idx+1;
    pos3d = traj_getPositionsByFrame(trajs,k);
    meanPos(idx,:) = mean(pos3d,1);
end

overallMean = mean(meanPos,1);
fprintf(1,' [done]\n');

fprintf(1,'Transforming dataset...');
for k = 1:length(trajectories)
    if isstruct(trajectories)
        trajectories(k).position =  trajectories(k).position - overallMean;
    else
        trajectories{k}(:,12:14) =  trajectories{k}(:,12:14) - overallMean;
    end
end
fprintf(1,' [done]\n');
end

