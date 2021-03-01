function [ rotation, translation ] = traj_transformLayFlat( pos3d )
% This function assumes, that a flat and parallel light sheet was used to
% record particles. This particle cloud has its largest extend in
% x-direction, 2nd largest in y, 3rd largest in z-direction. This resembles
% the data recorded in the PFC18 measurement campaign.

% find main axes of particle-cloud
translation = mean(pos3d,1);
pos3d = pos3d - translation;

Pyz = robustfit(pos3d(:,2),pos3d(:,3));
Rx = rodrigues(-atan(Pyz(2))*[1 0 0]);
for k = 1:length(pos3d)
    pos3d(k,:) = Rx*pos3d(k,:)';
end

Pxz = robustfit(pos3d(:,1),pos3d(:,3));
Ry = rodrigues(+atan(Pxz(2))*[0 1 0]);
for k = 1:length(pos3d)
    pos3d(k,:) = Ry*pos3d(k,:)';
end

Pxy = robustfit(pos3d(:,1),pos3d(:,2));
Rz = rodrigues(-atan(Pxy(2))*[0 0 1]);
for k = 1:length(pos3d)
    pos3d(k,:) = Rz*(pos3d(k,:))';
end

rotation    = Rz*Ry*Rx;

end

