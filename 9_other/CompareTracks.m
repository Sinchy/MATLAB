% number of tracks
track_no = unique(tracks(:, 5));
num_tracks = size(track_no, 1);
track_no_old = unique(tracks_old(:, 5));
num_tracks_old = size(track_no_old, 1);
diff = zeros(1, num_tracks);
connected = zeros(1, num_tracks);
match = cell(1, num_tracks);
     showTimeToCompletion; startTime=tic;
     percent = parfor_progress(num_tracks);
parfor i = 1 : num_tracks
    percent = parfor_progress;
        showTimeToCompletion( percent/100, [], [], startTime );
        
    track = tracks(tracks(:, 5) == track_no(i), :);
    length = size(track, 1);
    index_old_vector = [];
    index = 1;
%     j = 1;
    for j = 1 : length
        index_old = tracks_old(abs(tracks_old(:, 1) - track(j, 1)) < 1e-4 & ...
                abs(tracks_old(:, 2) - track(j, 2)) < 1e-4 & ...
                abs(tracks_old(:, 3) - track(j, 3)) < 1e-4, 5);
        if ~isempty(index_old) 
            jump = size(tracks_old(tracks_old(:, 5) == index_old, :), 1);
%             j = j + jump;
            if isempty(index_old_vector)
                index_old_vector(index) = index_old;
                index = index + 1;
            else
                if index_old ~= index_old_vector(index - 1)
                    index_old_vector(index) = index_old;
                    index = index + 1;
                end
            end
%         else
%             j = j + 1;
        end
    end
    if ~isempty(index_old_vector) 
        length_old = 0;
        connected(i) = size(index_old_vector, 2);
        match{i} = index_old_vector;
        for j = 1 : size(index_old_vector, 2)
            length_old = length_old + size(tracks_old(tracks_old(:, 5) == index_old_vector(1, j), :), 1);
        end
        diff(i) = length - length_old;
        
    else
        diff(i) = inf;
    end
end

parfor_progress(0);