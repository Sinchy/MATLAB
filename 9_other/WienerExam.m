track_no = unique(tracks_interest(:, 5));
label = zeros(1, length(track_no));
fig = figure;
series_wrong = [];
for i = 1 : length(track_no)
    track = tracks_interest(tracks_interest(:, 5) == track_no(i), :);
    if size(track, 1) < 6
        continue;
    end
    for j = 7 : size(track, 1)
        for k = 1 : 3
            h0 = 0.5 * ones(1, 5);
            [predict1, ~] = LMSWienerPredictor(track(1:j, k), 5, h0);
            h0 = -0.5 * ones(1, 5);
            [predict2, ~] = LMSWienerPredictor(track(1:j, k), 5, h0);
            if abs(predict2 - predict1) > 1e-1
                label(i) = k;
                series_wrong = [series_wrong; track(j-6:j, k)'];
                break;
            end
        end
        if label(i)
            break;
        end
    end
    if label(i)
        PlotTracks(track, fig, 'r.');
        hold on
        plot3(track(j, 1), track(j, 2), track(j, 3), 'b^');
    else
        PlotTracks(track, fig, 'g.');
        hold on
    end
end
