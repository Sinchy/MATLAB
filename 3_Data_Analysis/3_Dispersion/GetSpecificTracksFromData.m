function tracks = GetSpecificTracksFromData(data_map, trackID)
% using data map other than the matfile, can avoid using oversize memory
% which cause clash of computer.
tracks = data_map.Data.eulrot(ismember(data_map.Data.eulrot(:, 5), trackID), :);
end

