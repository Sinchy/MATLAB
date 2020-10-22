function allignment = PairDispersionStrainAllignment(data_map, pairs, VG, direction, frame_range)
% VG is a class variable for velocity gradient
% direction: forward 0, backward 1
% frame_range: relative frame range with respect to the starting frame
if direction == 0
    pairs(abs(pairs(:, 4)) < frame_range(1), :) = []; % delete short pairs
else
    pairs(abs(pairs(:, 5)) < frame_range(1), :) = [];
end
np = size(pairs, 1);
allignment  = cell(np, 1); % eigen values and the cosine of the angle with eigen vectors

trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);
[trackID, start_index, ic] = unique(tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, start_index, a_counts];

% frame information to get particles in a specific frame
[frame, ~, frame_sequence] = unique(data_map.Data.tracks(:, 4));
h = waitbar(0, 'processing...');

for i = 1 : np
    waitbar(i / np, h);
    track1_info = tr_info(tr_info(:, 1) == pairs(i, 1), :);
    track1 = tracks(track1_info(2) : track1_info(2) + track1_info(3) - 1, :);
    track2_info = tr_info(tr_info(:, 1) == pairs(i, 2), :);
    track2 = tracks(track2_info(2) : track2_info(2) + track2_info(3) - 1, :);   
    
    if direction == 0
        track1 = track1(track1(:,4) >= pairs(i, 3), :);
        track2 = track2(track2(:,4) >= pairs(i, 3), :);
    else
        track1 = track1(track1(:,4) <= pairs(i, 3), :);
        track2 = track2(track2(:,4) <= pairs(i, 3), :);
        track1 = flip(track1);
        track2 = flip(track2);
    end
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    
    if frame_range(2) < len
        len = frame_range(2);
    end
    
    allign = zeros(len - frame_range(1) + 1, 9);
    for j = len : -1: frame_range(1)
        disp_vec = track1(j, 1:3) - track2(j, 1:3);
        middle_point = 1/2 * (track1(j, 1:3) + track2(j, 1:3));
        
        frame_id = find(frame == track1(j, 4));
        particles = data_map.Data.tracks(frame_sequence == frame_id, :);
        du_dx = VG.Cal_CGVG_LSF(particles, middle_point, norm(disp_vec));
        if sum(du_dx(:)) == 0
            allign(1 : j - frame_range(1) + 1, :) = [];
            break; % if du_dx cann't be calculated, then it can't be calculated for the previous frames
        end
        strain = VG.StrainRate(du_dx);
        [V, D] = eig(strain, 'vector');
        allign(j - frame_range(1) + 1, 1:3) = [pairs(i, 1:2)  track1(j, 4)];
        allign(j - frame_range(1) + 1, 4:6) = D';
        for k = 1 : 3
             allign(j - frame_range(1) + 1, k + 6)  = dot(disp_vec,V(:, k))/(norm(disp_vec)*norm(V(:, k)));
        end
    end
    allignment{i} = allign;
end
%     allignment = cell2mat(allignment);
end

