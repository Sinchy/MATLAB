function [uv idx] = cameraProjectPoints(xyz, cameraMatrix, imsize)
% uv = cameraProjectPoints(xyz, cameraMatrix)
% Project the given world points onto the camera represented by
% cameraMatrix
%
% @param: xyz - 3D world points
%
% @param: cameraMatrix - 3 x 4 camera projection matrix

if ~all(size(cameraMatrix)==[3 4])
    error('invalid camera matrix shape');
end
if ~size(xyz,2) == 3
    error('expected 3D points');
end

uv = cameraMatrix * vertcat(xyz', ones(1, size(xyz,1)));
uv = uv(1:2,:) ./ repmat(uv(3,:), 2, 1);
uv = uv';
idx = 1:size(xyz,1);

if exist('imsize', 'var') && ~isempty(imsize)
    bad = any(uv > repmat(imsize, size(uv,1),1),2) | any(uv<0, 2);
    uv = uv(~bad,:);
    idx = find(~bad);
end

end