function PlotAlignedPairTracks(tracks, pairs)

addpath D:\0.Code\MATLAB\0_Math;

num_pairs = size(pairs, 1);

figure;
% Create zlabel
zlabel({'Z(mm)'});

% Create ylabel
ylabel({'Y(mm)'});

% Create xlabel
xlabel({'X(mm)'});
for i = 1 : 1000
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    if len < 2 
        continue;
    end
    % get the transverse and rotation vector
    T = [0 0 0] - track1(1, 1:3);
    direction = track1(2, 1:3) - track1(1, 1:3);
    U = TransformMatrixBetweenVectors(direction/norm(direction), [1 0 0]);
    
    track1_t = zeros(len, 3);
    track2_t = track1_t;
    for j = 1 : len
%         track1_t(j, 1:3) = U * (track1(j, 1:3) + T)';
%         track2_t(j, 1:3) = U * (track2(j, 1:3) + T)';
        track1_t(j, 1:3) =  (track1(j, 1:3) + T)';
        track2_t(j, 1:3) =  (track2(j, 1:3) + T)';
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
    h1.Color(4) = 0.1;
    h2.Color(4) = 0.1;
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

