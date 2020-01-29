% diff_tr = vecnorm(tracks(2:end, 1:3) - tracks(1:end-1, 1:3), 2, 2) > 0.005;

% num_part = size(tracks, 1);
tr_no = 1;
tr_no_vec = ones(num_part, 1);
for i = 2 : num_part
    if diff_tr(i -1)
        tr_no = tr_no + 1;
    end
%     tracks(:, 5) = tr_no;
    tr_no_vec(i) = tr_no;
end
