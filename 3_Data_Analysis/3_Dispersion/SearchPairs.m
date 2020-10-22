function pairs = SearchPairs(data_map,  d_0, min_pair_len)
% tracks need to be equal frame rate
tic
num_stat = 100000;
%track start frame and end frame
[trackID, start_index, ic] = unique(data_map.Data.tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, data_map.Data.tracks(start_index, 4), a_counts];

% frame sequence
[frame_no, ~, ic] = unique(data_map.Data.tracks(:,4));
frame_no_index = accumarray(ic,1:length(ic),[],@(x) {x}); % group the index of frame NO.
num_frame = length(frame_no);
seq_frame = randperm(num_frame);
frame_no_shuffle = frame_no(seq_frame);

f = waitbar(0,'Please wait...');
num_pairs = 0;

for i=1:1:length(frame_no)-1
%     if ~mod(i, 10)
%         save(pathname, 'pairs');
%     end
    frame = frame_no_shuffle(i);
    frame_index = frame_no == frame;
    particle_index = frame_no_index{frame_index};
    data = data_map.Data.tracks(particle_index , [1:5]);
%     data = data_map.Data.tracks(data_map.Data.tracks(:,4) == frame_no(i), [1:5]);
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

    %check track length
    n_p = size(new_pairs, 1);
    pair_len = zeros(n_p, 2);
    for k = 1 : n_p
        tr1_info = tr_info(tr_info(:, 1)  == new_pairs(k, 1), :);
        tr2_info = tr_info(tr_info(:, 1)  == new_pairs(k, 2), :);
        tr1_len = [tr1_info(3) - (frame - tr1_info(2)), frame - tr1_info(2)]; % tr len for the forward and backward
        tr2_len = [tr2_info(3) - (frame - tr2_info(2)), frame - tr2_info(2)]; 
        pair_len(k, :) = min([tr1_len; tr2_len]); % forward pair length, backward pair length
    end

    if isempty(pair_len)
        continue;
    end

    short_pair_index = pair_len(:, 1) < min_pair_len & pair_len(:, 2) < min_pair_len;
    new_pairs(short_pair_index, :) = []; %delete short track pairs
    pair_len(short_pair_index, :) = [];

    if isempty(new_pairs) 
        continue;
    end

    n_p = size(new_pairs, 1);
    pairs(num_pairs + 1 : num_pairs + n_p, 1:2) = new_pairs;
    pairs(num_pairs + 1 : num_pairs + n_p, 3) = frame;
    pairs(num_pairs + 1 : num_pairs + n_p, 4:5) = pair_len;
    num_pairs = num_pairs + n_p;
    waitbar(num_pairs/num_stat, f, 'processing...');
    if num_pairs >= num_stat
        break;
    end
end
toc
end


