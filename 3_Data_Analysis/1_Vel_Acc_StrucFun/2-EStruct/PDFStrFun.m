function [sample_strfun,sample_pairs] = PDFStrFun(data_map,redge_lin)
[frame_no, ~, ~] = unique(data_map.Data.tracks(:,4),'first');

num_frame = length(frame_no);
seq_frame = randperm(num_frame);
frame_no = frame_no(seq_frame);

num_bin = length(redge_lin)-1;
num_sample = 100000;
max_num_sample_perframe = 1000;
sample_count = zeros(num_bin, 1);
sample_strfun = zeros(num_bin, num_sample);
sample_pairs = cell(num_bin,1);
h = waitbar(0, 'Please wait...');
for i = 1 : length(frame_no)
    data = data_map.Data.tracks(data_map.Data.tracks(:,4) == frame_no(i), [1:3 12:14 5]);
    X = data(:, 1:3);
    u = data(:, 4:6);
    trID = data(:,7);
    data = [];
    distd=pdist(X);
    tmp = uint8(ones(size(X,1))); % use uint8 to save memory
    tmp = tril(tmp,-1); %# creates a matrix that has 1's below the diagonal

    %# get the indices of the 1's
    [rowIdx,colIdx ] = find(tmp); 
    rowIdx = uint32(rowIdx); colIdx = uint32(colIdx);
    tmp = []; % free the memory
    
    dr = X(rowIdx,:) - X(colIdx,:);
%     pairs = [trID(rowIdx), trID(colIdx), frame_no(i) * ones(length(rowIdx), 1)];
    drl = dr./repmat(sqrt(sum(dr.^2,2)),[1 3]);
    dr = []; % free the memory
    
        % structure function
    du = u(rowIdx,:) - u(colIdx,:);
    dul = sum(du .* drl, 2) / 1e3;
    drl = [];
%     dun = sqrt(sum(du .^ 2,2)-dul.^2);
    du = [];
    
    [~,c_log]=histc(distd',redge_lin);
    c_log(c_log == 0) = num_bin + 1;
%     hasdata = all(c_log>0, 2);
    
    strfun_gp = accumarray(c_log,dul,[],@(x) {x});
%     [xx, yy] = ndgrid(c_log,1:size(pairs,2));
%     pair_gp = accumarray([xx(:) yy(:)], pairs(:), [], @(x) {x});
    for j = 1 : num_bin
        if sample_count(j) > num_sample || sum(c_log == j) == 0
            continue;
        end
        num_elements = size(strfun_gp{j, 1}, 1); 
        if num_elements == 0
            continue;
        end
        if num_elements > max_num_sample_perframe
            num_elements = max_num_sample_perframe;
        end
        
        sample_strfun(j, sample_count(j) + 1 : sample_count(j) + num_elements) = strfun_gp{j, 1}(1:num_elements);
%         sample_pairs{j}(sample_count(j) + 1 : sample_count(j) + num_elements, :) = [pair_gp{j, 1}(1:num_elements), ...
%             pair_gp{j, 2}(1:num_elements), pair_gp{j, 3}(1:num_elements)];
        sample_count(j) = sample_count(j) + num_elements;
    end
    waitbar(sum(sample_count) /(num_bin * num_sample), h, 'processing...');
    if sum(sample_count >= num_sample)/num_bin >= 0.93
        break;
    end
end
end

