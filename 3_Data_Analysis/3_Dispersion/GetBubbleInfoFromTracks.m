function tracks_bubbleinfo = GetBubbleInfoFromTracks(tracks, bubble_info)
track_ID = unique(tracks(:,4:5), 'rows');
b_info = bubble_info(ismember(bubble_info(:, 1 : 2), track_ID(:, [2 1]), 'rows'), [3 21]); % bubble ID and data ID
tracks_bubbleinfo = [tracks, b_info];
end

