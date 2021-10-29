function tracks = CombineTracks(tracks1, tracks2)
tr_ID_max = max(tracks1(:, 5));
frame_no_max = max(tracks1(:,4));
if isempty(frame_no_max) 
    frame_no_max = 0;
end
tracks2(:, 4) = tracks2(:, 4) + frame_no_max;
tracks2(:, 5) = tracks2(:, 5) + tr_ID_max;
tracks = [tracks1; tracks2];
end

