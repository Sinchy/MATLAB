function tr_vel = CalVelAcc(tracks)
tracks = sortrows(tracks, 5);
trID = unique(tracks(:, 5));
num_tr = length(trID);
tr_vel = zeros(size(tracks, 1), 3);
n = 1;
for i = 1 : num_tr
    tr = tracks(tracks(:, 5) == trID(i), :);
    vel = tr(2:end, 1:3) - tr(1:end-1, 1:3);
    vel = [vel(1,:); vel];
    m = size(vel, 1);
    tr_vel(n : n + m -1, :) = vel;
    n = n + m;
end
end

