function tracks = LaVGetPortionFrame(tracks, frame_num)
% frame_num = 200;
% tracks = LaVision_tracks;
tracks = sortrows(tracks,9);
[No, ~]= find(tracks(:,9) == frame_num);
tracks(No(1):end, :) = [];
tracks = sortrows(tracks, 10);
end