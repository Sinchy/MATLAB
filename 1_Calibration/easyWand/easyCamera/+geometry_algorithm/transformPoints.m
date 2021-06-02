function out = transformPoints(points, T)
% Transform a set of points using the given transformation matrix
% usage: output = transformPoints(trajectory, transform);
%
% @param[in] trajectory - a vector of points. [n x 3]
%
% @param[in] transform - a 4 x 4 tranformation matrix
%
% @return the set of trajectories transformed by the given transformation
% matrix.
%
I = eye(4);
if all(all( abs(T-I) < .000001))
    out = points;
    return;
end
points = T * vertcat(points', ones(1, size(points,1)));
out = points(1:3,:)';