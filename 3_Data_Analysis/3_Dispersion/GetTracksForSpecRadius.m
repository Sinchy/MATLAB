function [tracks, bubble_info] = GetTracksForSpecRadius(tracks_all, Bdata_all, radius_range)
minRadius = radius_range(1);
maxRadius = radius_range(2);

ind=tracks_all(:,7)>=minRadius & tracks_all(:,7)<=maxRadius;

trID = unique(tracks_all(ind, 1));

tracks = Bdata_all(ismember(Bdata_all(:, 5), trID), :);

% bubble may change its size in their evolution
% delete those exceeding the radius requirement
bubble_info = tracks_all(ismember(tracks_all(:, 1), trID), :);
ind_2 = bubble_info(:,7) < minRadius - 0.05 | bubble_info(:,7) > maxRadius + 0.05;
trID_2 = unique(bubble_info(ind_2, 1));

tracks(ismember(tracks(:, 5), trID_2), :) = [];
bubble_info(ismember(bubble_info(:, 1), trID_2), :) = [];

% delete short tracks
[C,~,ic] = unique(tracks(:,5));
a_counts = accumarray(ic,1);
min_len = 100;
short_tr_ID = C(a_counts < min_len);

tracks(ismember(tracks(:, 5), short_tr_ID), :) = [];
bubble_info(ismember(bubble_info(:, 1), short_tr_ID), :) = [];

end
