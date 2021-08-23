function allignment = DNSSeparationAlignment(data_map, pairs, direction, frame_range, save_path, load_file)
tic
addpath D:\0.Code\MATLAB\2_Data_Extraction\5_GetDataFromJHU\JohnsHopkins_database_matlab_codes;
authkey = 'edu.yale.nicholas.ouellette-b0c68942';
dataset = 'isotropic1024coarse';
Lag4 = 'Lag4';
PCHIPInt = 'PCHIP';
FD4Lag4 = 'FD4Lag4';
VG = Coarse_grained_velocity_gradient;

if direction == 0
    pairs(abs(pairs(:, 4)) < frame_range(1), :) = []; % delete short pairs
else
    pairs(abs(pairs(:, 5)) < frame_range(1), :) = [];
end

num_pairs = size(pairs, 1);
if load_file
    load(save_path);
else
    allignment  = cell(num_pairs, 1); 
end
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

[trackID, start_index, ic] = unique(tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, start_index, a_counts];

% if num_pairs > 10000, num_pairs = 10000; end
% align_matrix = cell(num_pairs, 1);
% eigenvalue_matrix = cell(num_pairs, 1);
h = waitbar(0, 'processing...');
% h = parpool(15);
for i = 1 : num_pairs
    waitbar(i / num_pairs, h);
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
    
%     point1 = track1(track1(:,4) == pairs(i, 3), :);
%     point2 = track2(track2(:,4) == pairs(i, 3), :);
%     middle_point = 1/2 * (point1(1:3) + point2(1:3));

        disp_vec = track1(j, 1:3) - track2(j, 1:3);
        middle_point = 1/2 * (track1(j, 1:3) + track2(j, 1:3));
    
%     frame_no =pairs(i, 3); 
    frame_no = track1(j, 4); 
    frame_rate = 20;
    time = 0.005 + (frame_no - 1) / frame_rate;
    npoints = 100;
%     disp_vec = point1(1:3) - point2(1:3);
    filter_length = norm(disp_vec);
    points = (rand(npoints, 3) - 1/2 * ones(1, 3)) * filter_length + middle_point;
    count = 0;
    err_count = 0; 
    while count == err_count % if fail to obtain vel, then try again.
        try 
            vel = getVelocity(authkey, dataset, time, Lag4, PCHIPInt, npoints, points');
        catch
            err_count = err_count + 1;
            if err_count > 5 % if 5 attempts have been made, then give up and exit. 
                break;
            end
        end
        count = count + 1;
    end

    if err_count > 5
        warning('Fail to obtain velocity from JHTDB.');
%         break;
    end

     points(:, 6:8) = vel';
     du_dx = VG.Cal_CGVG_LSF(points, middle_point, filter_length);
     if sum(du_dx(:)) == 0
         warning('Particles are not uniformly distributed.');
         allign(1 : j - frame_range(1) + 1, :) = [];
            break; % if du_dx cann't be calculated, then it can't be calculated for the previous frames
%          break;
     end
     
    strain = VG.StrainRate(du_dx);
    [V, D] = eig(strain, 'vector');
%     align_matrix{i} = [dot(disp_vec,V(:, 1))/(norm(disp_vec)*norm(V(:, 1))), ...
%      dot(disp_vec,V(:, 2))/(norm(disp_vec)*norm(V(:, 2))), ...
%      dot(disp_vec,V(:, 3))/(norm(disp_vec)*norm(V(:, 3)))];
%     eigenvalue_matrix{i}= D';
        allign(j - frame_range(1) + 1, 1:3) = [pairs(i, 1:2)  track1(j, 4)];
        allign(j - frame_range(1) + 1, 4:6) = D';
        for k = 1 : 3
             allign(j - frame_range(1) + 1, k + 6)  = dot(disp_vec,V(:, k))/(norm(disp_vec)*norm(V(:, k)));
        end
    end
    allignment{i} = allign;
    
    if mod(i, 100) ~=0
        save(save_path, 'allignment');
    end
        
end
% align_matrix = cell2mat(align_matrix);
% eigenvalue_matrix = cell2mat(eigenvalue_matrix);
% delete(h);
toc
end

