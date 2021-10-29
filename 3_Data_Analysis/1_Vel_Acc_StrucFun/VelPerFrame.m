% velacc(:, 4:5) = velacc(:, [5 4]);
[C, ia, ic] = unique(tracks(:, 4));
num_frame = length(C);
vel_perframe = zeros(num_frame, 1);
for i = 1 : num_frame
    vel_frame = tracks(ic == C(i), 6:8);
    vel_perframe(i) = mean(vecnorm(vel_frame, 2, 2));
end