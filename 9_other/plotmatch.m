fig = figure;
for i = 1 : size(match, 2)
    if ~isempty(match{i})
        match_index = match{i};
        if size(match_index, 2) > 1
            PlotTracks(tracks(tracks(:, 5) == track_no(i), :), fig, 'b*');
            hold on
            for j = 1 : size(match_index, 2)
                track = tracks_old(tracks_old(:, 5) == match_index(j), :);
                PlotTracks(track, fig, 'r.');
                plot3(track(1,1), track(1,2), track(1,3), 'y*');
            end
        end
    else
%         track = tracks(tracks(:, 5) == track_no(i), :);
%         PlotTracks(track, fig, 'g.');
%         
%         hold on
    end
end

        