function [R, pairs, disp_matrix] = PairDispersion2(data_map, d_0, disp_rate, pathname, pairs)
% tracks need to be equal frame rate

% if ~exist('pairs', 'var')
num_stat = 50000;
pairs_label = zeros(num_stat, 2);
% num_frame_finished = 1000; %frames to finish searching

% pair_len_sample = zeros(3000,1);
% sample_num = 0;
% sample_frame = 0;
% min_sample_frame = 10;
% ratio = num_stat / num_frame_finished;

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
%     disp_rate = 0.0018;
    t0 = CalT0(disp_rate, mean(d_0));
    tr_len = t0 * 4000 * 5;
%      tr_len = 2000;
    if tr_len > 1500
        tr_len = 1500;
    end
%     %% plot for tr_len
%     
%         % Create figure
%     figure1 = figure;
% 
%     % Create axes
%     axes1 = axes('Parent',figure1);
%     hold(axes1,'on');
% 
%     % Create ylabel
%     ylabel({'L_{min}'});
% 
%     % Create xlabel
%     xlabel({'n'});
% 
%     box(axes1,'on');
%     hold(axes1,'off');
%     % Set the remaining axes properties
%     set(axes1,'FontSize',20,'LineWidth',2);
%     
%     update_times = 1;
%     
%     plot(update_times, tr_len, 'bo', 'LineWidth', 2);
% %     update_times = update_times + 1;
%     hold on;

%%
    
    
%       tr_len = 1400;
    [frame_no, ~, ~] = unique(data_map.Data.tracks(:,4),'first');
    num_frame = length(frame_no);
    seq_frame = randperm(num_frame);
    frame_no = frame_no(seq_frame);

%         pairs_label = zeros(num_stat, 2);
    f = waitbar(0,'Please wait...');

    for i=1:1:length(frame_no)-1
        if ~mod(i, 10)
            save(pathname, 'pairs');
        end
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
        tracks(tracks(:, 4) < frame_no(i), :) = []; % count the len from current frame on
        [trackID,~,trIndex] = unique(tracks(:,5));
        track_len = accumarray(trIndex,1);
        
        n_p = size(new_pairs, 1);
        pair_tr_len = zeros(n_p, 2);
        for k = 1 : n_p
            pair_tr_len(k, :) = [track_len(trackID == new_pairs(k, 1)), track_len(trackID ==  new_pairs(k, 2))];
        end
        
        pair_len = min(pair_tr_len, [], 2);
        if isempty(pair_len)
            continue;
        end
%         if sample_num < 3000 || sample_frame < min_sample_frame
%             pair_len_sample(sample_num + 1 : sample_num + n_p) = pair_len;
%             sample_num = sample_num + n_p;
%             pair_len_sample = sort(pair_len_sample,'descend');                          % Sort Descending
%             percent = ratio / (sample_num / i); 
%             if percent > 1
%                 percent = 1;
%             end
%             index = ceil(length(nonzeros(pair_len_sample)) * percent);
%             if index < length(nonzeros(pair_len_sample))
%                 len = pair_len_sample(index);   
%                 if len ~= 0
%                     sample_frame = sample_frame + 1;
%                     tr_len1 = len;
%                 end
%             end
%             
%             
% %             tr_len = mean(pair_len_sample(1:ceil(length(nonzeros(pair_len_sample)) * percent))) * 0.9  % take the top ten percent of data to be the length criteria
% %             pair_len_sort = sort(pair_len,'descend');     
% %             tr_len_0 = mean(pair_len_sort(1:ceil(length(nonzeros(pair_len_sort)) * percent)));
% %             tr_len = (tr_len + tr_len_0) / 2
%             if i == min_sample_frame
%                 tr_len = tr_len1
% %                 update_times = update_times + 1;
% %                 plot(update_times, tr_len, 'bo', 'LineWidth', 2);
%                 
%             end
%         else
%             tr_len = tr_len1
% %             update_times = update_times + 1;
% %             plot(update_times, tr_len, 'bo', 'LineWidth', 2);
%             sample_frame = 0;
%             sample_num = 0;
%             pair_len_sample = zeros(3000,1); % every 3000 samples, empty and reestimate
%         end
%         tr_len = 0;
        
        short_pair_index = pair_len < tr_len ;
        new_pairs(short_pair_index, :) = []; %delete short track pairs
        new_pairs_label(short_pair_index, :) = []; 
        
%         short_track_ID = trackID(track_len < tr_len);
%         short_track_pairs_index = sum(ismember(new_pairs, short_track_ID), 2) >= 1;
%         new_pairs(short_track_pairs_index, :) = []; %delete short track pairs
%         new_pairs_label(short_track_pairs_index, :) = []; 


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
%     vel_vec = track1(1 : len, 6:8) - track2(1 : len, 6:8);
    disp_sca = vecnorm(disp_vec, 2, 2) ;
    disp_matrix(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1)) .^2 ;
%     disp_matrix(i, 1 : len - 1) = (disp_sca(2:end) - disp_sca(1));
%     disp_sca = disp_vec * disp_vec(1,:)'; % corelation with the initial separation
%     disp_sca = vel_vec * disp_vec(1,:)';
%     disp_matrix(i, 1 : len) = disp_sca;
%     disp_vec = disp_vec - disp_vec(1, 1:3);
%     disp_matrix(i, 1 : len - 1) = vecnorm(disp_vec(2:end, 1:3), 2, 2) .^ 2;
%     disp_matrix(i, 1 : len) = vecnorm(disp_vec(:, 1:3), 2, 2) .^ 2;
end

%remove repeated pair
[~,index,~] = unique(disp_matrix(:,1));
disp_matrix = disp_matrix(index, :);
pairs = pairs(index, :);

len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
R = zeros(len - 1, 1);
for i = 1 : len - 1
    disp = nonzeros(disp_matrix(:, i));
    if ~isempty(disp)
        R(i) = mean(disp);
    end
end
R = nonzeros(R);

save(pathname, 'pairs', 'disp_matrix', 'R');
end

