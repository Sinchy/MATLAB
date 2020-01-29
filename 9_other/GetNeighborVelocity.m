num_track = max(tracks(:,5));

for i = 1 : num_track
   track = tracks(tracks(:,5) == i, :);
   min_frame = min(track(:, 4));
   max_frame = max(track(:, 4));
   for j = 1 : max_frame - min_frame
       frame_part = tracks(tracks(:, 4) == min_frame + j, :);
       dist = vecnorm(frame_part(:, 1:3) - track(j + 1, 1:3), 2, 2);
       frame_part = [frame_part dist];
       neighbor_part = frame_part(dist < 5, :);
       neighbor_part = sortrows(neighbor_part, 6);
       if size(neighbor_part, 1) > 50
           neighbor_part = neighbor_part(1:50, :);
       end
       frame_prev = tracks(tracks(:, 4) == min_frame + j -1, :);
       for k = 1 : size(neighbor_part, 1)
           part_prev = frame_prev(frame_prev(:,5) == neighbor_part(k, 5), :);
           if ~isempty(part_prev)
                neighbor_vel(k) = norm(neighbor_part(k, 1:3) -  part_prev(1, 1:3));
           end
       end
       mean_vel = mean(nonzeros(neighbor_vel));
       std_vel = std(nonzeros(neighbor_vel));
       part_vel = norm(track(j+1, 1:3) - track(j, 1:3));
       track(j + 1, 7:9) = [mean_vel std_vel abs(part_vel - mean_vel)/std_vel];
   end
end