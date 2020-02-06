function [bubble_tracer_pair, tracer_pair, tracer_track] = GetTracksAroundBubble(bubble_info, search_range)
% The information of the bubbles. which data set does it belong to?
bb_tr_id = unique(bubble_info(:,1));

num_bb_tr = length(bb_tr_id);

load_data_id = 0;
data = [];
fid = fopen('particleTracks_Dir.txt');
file_path = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
bubble_tracer_pair = cell(num_bb_tr, 1); % save the pair information: data set ID, bubble ID and tracer ID
tracer_pair = cell(num_bb_tr, 1); % save the pair information: data set ID, tracer ID
tracer_track = cell(num_bb_tr, 1); % save the tracer tracks
f = waitbar(0,'Please wait...');
for i = 1 : num_bb_tr 
    waitbar(i/num_bb_tr, f, 'processing...');
    initial_info = bubble_info(find(bubble_info(:,1) == bb_tr_id(i), 1), :);
    data_id = initial_info(21);
    
    if data_id ~= load_data_id % if the data is different from the one which has been loaded.
        try
            file_data = load(file_path{1, 1}{data_id});
            load_data_id = data_id;
            if data_id < 35
                data = file_data.vel_acc_data;
            else
                data = file_data.filter_data;
            end
            file_data = [];
        catch
            continue;
        end
    end
    bb_pos = initial_info(4:6);
    frame_no = initial_info(2); 
    particles = data(data(:, 4) == frame_no, :);
    if isempty (particles) 
        continue;
    end
    dist = vecnorm(particles(:,1:3) - bb_pos, 2, 2);
    neighbor_tr_ID = particles(dist > search_range(1) & dist < search_range(2), 5); % get the track ID
    if isempty (neighbor_tr_ID) 
        continue;
    end
    pair_info = [];
    pair_info(:, 3) = neighbor_tr_ID;
    pair_info(:, 1) = data_id; 
    pair_info(:, 2) = bb_tr_id(i);
    bubble_tracer_pair{i} = pair_info;
    
    % get tracer pair
    num_neighbor_tr = length(neighbor_tr_ID);
    neighbor_tr_pair = cell(num_neighbor_tr, 1);
    for j = 1 : num_neighbor_tr
        tr_pos = particles(particles(:, 5) == neighbor_tr_ID(j), 1:3);
        dist = vecnorm(particles(:,1:3) - tr_pos, 2, 2);
        tracer_pair_ID = particles(dist > search_range(1) & dist < search_range(2), 5); 
        if isempty (tracer_pair_ID) 
            continue;
        end
        pair_info = [];
        pair_info(:, 3) = tracer_pair_ID;
        pair_info(:, 1) = data_id; 
        pair_info(:, 2) = neighbor_tr_ID(j);
        pair_info(:, 4) = frame_no; % nark the start frame no.
        neighbor_tr_pair{j} = pair_info;
    end
    neighbor_tr_pair = neighbor_tr_pair(~cellfun('isempty',neighbor_tr_pair)); % delete empty element
    if ~isempty(neighbor_tr_pair)
        tracer_pair{i} = cell2mat(neighbor_tr_pair);
        % save the tracer track
        total_tr_ID = unique([neighbor_tr_ID; tracer_pair{i}(:,3)]);
    else
        total_tr_ID = neighbor_tr_ID;
    end
    tracer_track{i} = data(ismember(data(:, 5), total_tr_ID), :);
    tracer_track{i}(:, 15) = data_id;
end
    bubble_tracer_pair = bubble_tracer_pair(~cellfun('isempty',bubble_tracer_pair)); % delete empty element
    tracer_pair = tracer_pair(~cellfun('isempty',tracer_pair)); 
    tracer_track = tracer_track(~cellfun('isempty',tracer_track)); 
end

