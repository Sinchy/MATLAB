function num_trackable = TrackableNum(overlap, thred)
n_frame = size(overlap, 1);
num_trackable = zeros(n_frame, 1); 
for i = 1 : n_frame
    frame_overlap = overlap{i};
    label_trackable = frame_overlap(:, 1:end-1) < thred &  frame_overlap(:, 1:end-1) >= 0;
    label_trackable = sum(label_trackable, 2);
    ind = label_trackable >= 2 ;
    num_trackable(i) = sum(ind);
end
end

