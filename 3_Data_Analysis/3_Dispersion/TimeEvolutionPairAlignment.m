function [align_matrix1, align_matrix2, align_matrix3, eigenvalue_matrix] = TimeEvolutionPairAlignment(data_map, pairs, VG, direction, is_DNS)

if is_DNS
    addpath D:\0.Code\MATLAB\2_Data_Extraction\5_GetDataFromJHU\JohnsHopkins_database_matlab_codes;
    authkey = 'edu.yale.nicholas.ouellette-b0c68942';
    dataset = 'isotropic1024coarse';
    Lag4 = 'Lag4';
    PCHIPInt = 'PCHIP';
    FD4Lag4 = 'FD4Lag4';
end

num_pair = size(pairs, 1);
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

[trackID, start_index, ic] = unique(tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, start_index, a_counts];

if direction == 0
    max_pair_len = max(pairs(:, 4));
else
    max_pair_len = max(abs(pairs(:,5)));
end

align_matrix1 = zeros(num_pair, max_pair_len);
align_matrix2 = zeros(num_pair, max_pair_len);
align_matrix3 = zeros(num_pair, max_pair_len);
eigenvalue_matrix = zeros(num_pair, max_pair_len, 3);
h = waitbar(0, 'processing...');

% frame information to get particles in a specific frame
[frame, ~, frame_sequence] = unique(data_map.Data.tracks(:, 4));

for i = 1 : num_pair
    waitbar(i / num_pair, h);
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

    for j = 1 : len
        disp_vec = track1(j, 1:3) - track2(j, 1:3);
        middle_point = 1/2 * (track1(j, 1:3) + track2(j, 1:3));
        
        frame_id = find(frame == track1(j, 4));
        particles = data_map.Data.tracks(frame_sequence == frame_id, :);
        filter_length = norm(disp_vec);
        du_dx = VG.Cal_CGVG_LSF(particles, middle_point, filter_length);
        if sum(du_dx(:)) == 0
            if is_DNS
                % then obtain the data from DNS data source
                frame_no =track1(j, 4); 
                frame_rate = 20;
                time = 0.005 + (frame_no - 1) / frame_rate;
                npoints = 100;
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
                    break;
                end
                
                 points(:, 6:8) = vel';
                 du_dx = VG.Cal_CGVG_LSF(points, middle_point, filter_length);
                 if sum(du_dx(:)) == 0
                     warning('Particles are not uniformly distributed.');
                     break;
                 end

            else
                warning('Number of particles may not be enough\n');
                break; % if du_dx cann't be calculated, then it can't be calculated for the previous frame
            end
        end
        strain = VG.StrainRate(du_dx);
        [V, D] = eig(strain, 'vector');
        align_matrix1(i, j) = dot(disp_vec,V(:, 1))/(norm(disp_vec)*norm(V(:, 1)));
        align_matrix2(i, j) = dot(disp_vec,V(:, 2))/(norm(disp_vec)*norm(V(:, 2)));
        align_matrix3(i, j) = dot(disp_vec,V(:, 3))/(norm(disp_vec)*norm(V(:, 3)));
        eigenvalue_matrix(i, j, :) = D';
    end
end
end

