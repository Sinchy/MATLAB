function pair_gp = GetPairsMARCC(datapath, len_kol, Re_t)
% load data
load([datapath '.mat']);
fileID = fopen([datapath '_bin.mat'], 'w');
fwrite(fileID, filter_data, 'double'); % save the data
fclose(fileID);
[row, col] = size(filter_data);
data_map = memmapfile([datapath '_bin.mat'], 'Format',{'double',[row col],'tracks'});
[frame_no, ~, ~] = unique(filter_data(:,4),'first');
clear filter_data;

Re = Re_t ^ 2 /10;
n = round(Re ^ (3/4));
d_0 = [0.1 5:5:n] * len_kol;
num_pair_gp = length(d_0);
pair_gp = cell(length(frame_no), num_pair_gp);
h = parpool(4);
parfor i=1:1:length(frame_no)-1
    
    data = data_map.Data.tracks(data_map.Data.tracks(:, 4) == frame_no(i), [1:5]);
	distd=pdist(data(:, 1:3));

    tmp = ones(size(data,1)); % use uint8 to save memory
    tmp = tril(tmp,-1); %# creates a matrix that has 1's below the diagonal

    %# get the indices of the 1's
    [rowIdx,colIdx ] = find(tmp); 
%         rowIdx = uint32(rowIdx); colIdx = uint32(colIdx);

    [~,c_lin]=histc(distd',d_0);
    
    for j = 1 : num_pair_gp
        pA = data(rowIdx(c_lin == j), 5);
        pB = data(colIdx(c_lin == j), 5);
        new_pairs = [pA pB]; 
        new_pairs(:, 3) = frame_no(i);
        
        % get the len
        trackID = unique([new_pairs(:,1); new_pairs(:,2)]);
        tracks = GetSpecificTracksFromData(data_map, trackID);
        tracks1 = tracks(tracks(:, 4) >= frame_no(i), :); % count the len from current frame on 
        [trackID,~,trIndex] = unique(tracks1(:,5));
        track_len = accumarray(trIndex,1); % forward length
        n_p = size(new_pairs, 1);
        pair_tr_len = zeros(n_p, 2);
        for k = 1 : n_p
            pair_tr_len(k, :) = [track_len(trackID == pA(k)), track_len(trackID == pB(k))];
        end
        
        pair_len_forward = min(pair_tr_len, [], 2);
        
        tracks2 = tracks(tracks(:, 4) <= frame_no(i), :); 
        [trackID,~,trIndex] = unique(tracks2(:,5));
        track_len = accumarray(trIndex,1); % backward length
        for k = 1 : n_p
            pair_tr_len(k, :) = [track_len(trackID == pA(k)), track_len(trackID == pB(k))];
        end
        pair_len_backward = min(pair_tr_len, [], 2);
        
        pairs = [new_pairs, pair_len_forward, pair_len_backward];
        pair_gp{i, j} = pairs;
    end

end
save([datapath '_pairs.mat'], 'pair_gp', 'data_map', '-v7.3');
delete(h);
end

