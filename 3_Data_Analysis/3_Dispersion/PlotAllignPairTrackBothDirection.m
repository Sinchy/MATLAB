function PlotAllignPairTrackBothDirection(data_map, pairs)

addpath D:\0.Code\MATLAB\0_Math;

pairs = pairs(pairs(:, 4) > 1400 & pairs(:, 5) <-1400, :);
tracks = data_map.Data.tracks(ismember(data_map.Data.tracks(:, 5), pairs(:, 1:2)), :);
num_pairs = size(pairs, 1);

figure;
% Create zlabel
zlabel({'Z(mm)'});

% Create ylabel
ylabel({'Y(mm)'});

% Create xlabel
xlabel({'X(mm)'});
for i = 1 : num_pairs
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    start_frame = max([track1(1, 4), track2(1,4)]);
    end_frame = min([track1(end, 4), track2(end,4)]);
    track1 = track1(track1(:, 4) >= start_frame & track1(:, 4) <= end_frame, :);
    track2 = track2(track2(:, 4) >= start_frame & track2(:, 4) <= end_frame, :);
    len = end_frame - start_frame;
    if len < 2 
        continue;
    end
    % get the transverse and rotation vector
    start_point1 = track1(track1(:, 4) == pairs(i, 3), 1:3);
    start_point2 = track1(track1(:, 4) == pairs(i, 3) + 1, 1:3);
    T = [0 0 0] - start_point1;
    direction = start_point1 - start_point2;
    U = TransformMatrixBetweenVectors(direction/norm(direction), [1 0 0]);
    
    track1_t = zeros(len, 3);
    track2_t = track1_t;
    for j = 1 : len
        track1_t(j, 1:3) = U * (track1(j, 1:3) + T)';
        track2_t(j, 1:3) = U * (track2(j, 1:3) + T)';
%         track1_t(j, 1:3) =  (track1(j, 1:3) + T)';
%         track2_t(j, 1:3) =  (track2(j, 1:3) + T)';
    end
        h1 = plot3(track1_t(:,1), track1_t(:,2), track1_t(:,3), 'b-');
    axis equal
    hold on;
        % Create zlabel
    zlabel({'Z(mm)'});

    % Create ylabel
    ylabel({'Y(mm)'});

    % Create xlabel
    xlabel({'X(mm)'});
    h2 = plot3(track2_t(:,1), track2_t(:,2), track2_t(:,3), 'b-');
%     h1.Color(4) = 0.1;
%     h2.Color(4) = 0.1;
    axis equal
%     n0 = min(len, 100);
%     h = plot3(track1_t(1:n0,1), track1_t(1:n0,2), track1_t(1:n0,3), 'b-');
%     h.Color(4) = 0.15;
%     hold on;
%     h = plot3(track2_t(1:n0,1), track2_t(1:n0,2), track2_t(1:n0,3), 'b-');
%     h.Color(4) = 0.15;
%     if len > n0
%         h = plot3(track1_t(n0:end,1), track1_t(n0:end,2), track1_t(n0:end,3), 'r-');
%         h.Color(4) = 0.15;
%         hold on;
%         h = plot3(track2_t(n0:end,1), track2_t(n0:end,2), track2_t(n0:end,3), 'r-');
%         h.Color(4) = 0.15;
%     end
end
end

