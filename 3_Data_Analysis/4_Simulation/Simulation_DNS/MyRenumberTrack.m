function data = MyRenumberTrack(data)
%this function is used to renumber the track at a big jump at the edge
data = sortrows(data, 5);
tr_ID = unique(data(:,5));
num_tr = size(tr_ID, 1);
tr_no = num_tr;
no_sequence = zeros(size(data, 1), 1);
start = 1;
for i = 1 : num_tr
    track = data(data(:,5) == tr_ID(i), :);
    dx = vecnorm(track(2:end, 1:3) - track(1:end-1, 1:3), 2, 2);
    jump_index = find(dx > pi);
    if isempty(jump_index)
        continue;
    end
    num_jump = size(jump_index, 1);
    index = jump_index(1) + 1;
    for j = 1 :  num_jump
       if j < num_jump
           track(index:jump_index(j + 1), 5) = tr_no + 1;
           tr_no = tr_no + 1;
           index = jump_index(j + 1) + 1;
       else
           track(jump_index(j) + 1 : end, 5) = tr_no + 1;
           tr_no = tr_no + 1;
       end
    end
    len = size(track, 1);
    no_sequence(start : start + len - 1) = track(:, 5);
    start = start + len;
end
data(:, 5) = no_sequence;
end

