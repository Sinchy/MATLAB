function err_vec =  LinearFitError(data)
track_no = unique(data(:,5));
num_track = size(track_no, 1);
if num_track > 50000, num_track = 50000; end
err_vec = [];
for j = 1 : num_track
    track = data(data(:,5) == track_no(j), :);
    num_frame = size(track, 1);
    for i = 4 : num_frame
        x = [1 1; 1 2; 1 3; 1 4];
        y = track(i - 3 : i, 1 : 3);
        b = x \ y;
        y_cal = x * b;
        err(i) = norm(y_cal(end, :) - y(end, :));
    end
%     err_vec(j,1) = mean(nonzeros(err));
    err_vec = [err_vec err];
end
end

