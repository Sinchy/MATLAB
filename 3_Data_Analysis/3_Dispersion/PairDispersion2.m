function [R, pairs, disp_matrix] = PairDispersion2(data_map, d_0, pairs)
% tracks need to be equal frame rate

% if ~exist('pairs', 'var')
num_stat = 3000;
pairs_label = zeros(num_stat, 2);

num_pairs = 0;
if exist('pairs', 'var')
    pairs_nonzero = pairs(pairs(:,1) > 0, :);
    num_pairs = size(pairs_nonzero, 1); 
    pairs_label(1 : num_pairs, :) = [pairs_nonzero(:,1) + pairs_nonzero(:,2), ...
        pairs_nonzero(:,1) .* pairs_nonzero(:,2)];
else
    pairs = zeros(num_stat, 3);
end

if ~exist('pairs', 'var') || num_pairs < num_stat
%     if num_pairs < num_stat
    %     tr_len = 1000;
    disp_rate = 0.07;
    t0 = CalT0(disp_rate, mean(d_0));
    tr_len = t0 * 4000 * 20;
     tr_len = 2000;
%     if tr_len > 1500
%         tr_len = 1500;
%     end

    [frame_no, ~, ~] = unique(data_map.Data.tracks(:,4),'first');
    num_frame = length(frame_no);
    seq_frame = randperm(num_frame);
    frame_no = frame_no(seq_frame);

%         pairs_label = zeros(num_stat, 2);
    f = waitbar(0,'Please wait...');
    for i=1:1:length(frame_no)-1
        data = data_map.Data.tracks(data_map.Data.tracks(:,4) == frame_no(i), [1:5]);
        distd=pdist(data(:, 1:3));

        tmp = ones(size(data,1)); % use uint8 to save memory
        tmp = tril(tmp,-1); %# creates a matrix that has 1's below the diagonal

        %# get the indices of the 1's
        [rowIdx,colIdx ] = find(tmp); 
%         rowIdx = uint32(rowIdx); colIdx = uint32(colIdx);
        clear tmp; % free the memory

        [~,c_lin]=histc(distd',d_0);

        pA = data(rowIdx(c_lin == 1), 5);
        pB = data(colIdx(c_lin == 1), 5);
        new_pairs = [pA pB];
        % check whether there is any repeating pairs in new_pairs and
        % pairs.

        new_pairs_label = [new_pairs(:,1) + new_pairs(:,2), new_pairs(:,1) .* new_pairs(:,2)];
        repeat_index = ismember(new_pairs_label, pairs_label, 'rows');
        new_pairs(repeat_index,:) = []; 
        new_pairs_label(repeat_index,:) = [];
%         n_p = size(new_pairs, 1);

        %check track length
        trackID = unique([new_pairs(:,1); new_pairs(:,2)]);
        tracks = GetSpecificTracksFromData(data_map, trackID);
        [trackID,~,trIndex] = unique(tracks(:,5));
        track_len = accumarray(trIndex,1);
        short_track_ID = trackID(track_len < tr_len);
        short_track_pairs_index = sum(ismember(new_pairs, short_track_ID), 2) >= 1;
        new_pairs(short_track_pairs_index, :) = []; %delete short track pairs
        new_pairs_label(short_track_pairs_index, :) = []; 

        if isempty(new_pairs) 
            continue;
        end

        n_p = size(new_pairs, 1);
        pairs(num_pairs + 1 : num_pairs + n_p, 1:2) = new_pairs;
        pairs(num_pairs + 1 : num_pairs + n_p, 3) = frame_no(i);
        pairs_label(num_pairs + 1 : num_pairs + n_p, :) = new_pairs_label;
        num_pairs = num_pairs + n_p;
        waitbar(num_pairs/num_stat, f, 'processing...');
        if num_pairs >= num_stat
            break;
        end
    end
end
% end
pairs(pairs(:,1) == 0, :) = []; 
pairs(num_stat + 1:end, :) = []; 
num_pair = size(pairs, 1);
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
disp_matrix = zeros(num_pair, len);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    disp_vec = track1(1 : len, 1:3) - track2(1 : len, 1:3);
    vel_vec = track1(1 : len, 6:8) - track2(1 : len, 6:8);
%     disp_sca = vecnorm(disp_vec, 2, 2);
%     disp_matrix(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1)) .^ 2;
%     disp_sca = disp_vec * disp_vec(1,:)'; % corelation with the initial separation
    disp_sca = vel_vec * disp_vec(1,:)';
    disp_matrix(i, 1 : len) = disp_sca;
%     disp_vec = disp_vec - disp_vec(1, 1:3);
%     disp_matrix(i, 1 : len - 1) = vecnorm(disp_vec(2:end, 1:3), 2, 2) .^ 2;
end
len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
R = zeros(len - 1, 1);
for i = 1 : len - 1
    disp = nonzeros(disp_matrix(:, i));
    if ~isempty(disp)
        R(i) = mean(disp);
    end
end
R = nonzeros(R);
end

