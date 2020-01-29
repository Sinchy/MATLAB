function diff_angle_vec = VelocityAngleCheck(data)
% data = good_tracks;
track_no = unique(data(:,5));
num_track = size(track_no, 1);
if num_track > 50000, num_track = 50000; end
for j = 1 : num_track
    track = data(data(:,5) == track_no(j), :);
    num_frame = size(track, 1);
    for i = 4 : num_frame
        vel1 = track(i, 1:3) - track(i - 1, 1:3);
        vel2 = track(i - 1, 1:3) - track(i - 2, 1:3);
        vel3 = track(i - 2, 1:3) - track(i - 3, 1:3);
        angle1 = atan2d(norm(cross(vel1,vel2)),dot(vel1,vel2));
        angle2 = atan2d(norm(cross(vel2,vel3)),dot(vel2,vel3));
        track(i, 6) = abs(angle2 - angle1);
    end
    diff_angle_vec(j,1) = mean(track(:,6));
%     data(data(:,5) == track_no(j), 6) = track(:, 6);
end

% track_no = unique(data(:,5));
% num_track = size(track_no, 1);
% for j = 1 : num_track
%     track = data(data(:,5) == track_no(j), :);
% if size(track, 1) > 4
%         vel1 = track(end, 1:3) - track(end - 1, 1:3);
%         vel2 = track(end - 1, 1:3) - track(end - 2, 1:3);
%         vel3 = track(end - 2, 1:3) - track(end - 3, 1:3);
%         acc1 = norm(vel1 - vel2);
%         acc2 = norm(vel2 - vel3);
%         diff_acc(j) = abs(acc1 - acc2);
% end
% end
end