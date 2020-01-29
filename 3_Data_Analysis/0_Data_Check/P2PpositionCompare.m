function mean_error = P2PpositionCompare(tracks, tracks_STB)
mean_error = zeros(100,1);
for i = 51 : 100
    i
    original = tracks(tracks(:,4) == i, :);
    tracked = tracks_STB(tracks_STB(:, 4) == i, :);
    mean_error(i) = PositionCompare(original, tracked);
end
end

