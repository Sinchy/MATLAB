function tracks2D = TracksToMatrix(tracks, frame_num)
% to convert track into matrix, only frame number less than frame_num would
% be gotten.
% tracks = active_long_tracks; 
[No_track, No_frame, ~] = size(tracks); 
if (frame_num > No_frame) frame_num = No_frame; end 
for i = 1 : No_track
    for j = 1 : frame_num
        if(tracks(i,j,1)~= 0 || tracks(i,j,2) ~= 0 || tracks(i,j,3) ~= 0) 
            tracks2D((i - 1) * frame_num + j, :) = [tracks(i,j,1), tracks(i,j,2), tracks(i,j,3), i, j];
        end
    end
end

end