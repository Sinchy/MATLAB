mean_vel_lost_cd = zeros(2000, 3);
start_frame = min(data_lost_cd_vel(:,4));
end_frame = max(data_lost_cd_vel(:,4));
for i = start_frame : end_frame
    mean_vel_lost_cd(i, 1:3) = mean(data_lost_cd_vel(data_lost_cd_vel(:,4) == i, 6:8));
end