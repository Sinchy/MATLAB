%% add overlap information to tracks
tracks0c = sortrows(tracks0c, 5);
tracks0c = sortrows(tracks0c, 4);
for i = 1 : 250
    tracks0c((i - 1) * 1250 + 1 : i * 1250, 12 : 16) = overlap{i};
end

%% at frame 240
frame_no = 240;
frame = tracks0c(tracks0c(:, 4) == frame_no, :);
frame = frame(frame(:, 6) == 0, :);
frame(sum(frame(:, 12:15) == -1, 2) >= 1, :) =[]; % out of image
frame(sum(frame(:, 12:15) >= .8, 2) > 2, :) = []; % totally overlap more than 1 camera
%% 
frame(:, 16) = sum(frame(:, 12:14),  2)/3;

%% for each particle, it should be trackable for more than 7 frames 
n_p = size(frame, 1);
trackable = ones(n_p, 1);

for i = 1 : size(frame, 1)
    tr_ID = frame(i, 5);
    frame_t = tracks0c(ismember(tracks0c(:, 4), frame_no:frame_no + 7) & tracks0c(:, 5) == tr_ID, :);
    if sum(sum(frame_t(:, 12:15) == -1, 2) >= 1) >= 1 || sum(sum(frame_t(:, 12:15) >= .8, 2) > 1) >= 1
        trackable(i) = 0;
    end
end

%% rearranging track ID
tracks0c = sortrows(tracks0c, 5);
tr_no = unique(tracks0c(:,5));
n_tr = length(tr_no);
max_tr_no = max(tr_no) + 1;
for i = 1 : n_tr
    track = tracks0c(tracks0c(:,5) == tr_no(i), :);
     diff = vecnorm(track(2:end, 1:3) - track(1:end-1, 1:3), 2, 2);
    TF = abs(diff) > 0.5;
    l = length(TF);
    for j = 1 : l
        if (TF(j))
            track(j + 1 : end, 5) = max_tr_no;
            max_tr_no = max_tr_no + 1;
        end
    end
    tracks0c(tracks0c(:,5) == tr_no(i), :) = track;
end

%% obtain the overlapping limit for tracked bubble
[~, ia, ~] = unique(tracks0c(:,10), 'last');
[tr_no, ia2, ~] = unique(tracks0c(:,5), 'last');
tr_last = tracks0c(ia, :);
ind = zeros(length(ia), 1);
for i = 1 : length(ia)
    % get the last frame
    last_frame = tracks0c(ia2(tr_no == tr_last(i, 5)), 4);
    if (tr_last(i, 9) == last_frame) 
        ind(i) = 1;
    end
end
ind = logical(ind);
ia(ind) = [];
ia(ia == size(tracks0c, 1)) = [];
tr_last = tracks0c(ia + 1, :);
% tr_last(logical(ind), :) = [];
overlap_last = tr_last(:, 12:15);
ind_out = sum(overlap_last(:, 1:4) < 0, 2) >= 1;
overlap_last(ind_out, :) = [];
tr_last(ind_out, :) = [];
tr_last(1,:) =[];
overlap_last(1, :) =[];
% delete particles that are too close
ind = zeros(size(tr_last, 1), 1);

for i = 1 : size(tr_last, 1)
    frame_no = tr_last(i, 4);
    frame = tracks(tracks(:, 4)== frame_no, 1:3);
    dist = vecnorm(frame(:, 1:3) - tr_last(i, 1:3), 2, 2);
    if sum(dist < 0.1) > 0
        ind(i) = 1; 
    end
end
ind = logical(ind);

tr_last(ind, :) = [];
overlap_last(ind, :) = [];
overlap_last(overlap_last(:, 1:4) > 1) = 1;
overlap_last_m = (sum(overlap_last, 2) - min(overlap_last,[], 2)) /3;


