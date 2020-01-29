datapath = '/media/Share2/Projects/1-Bubble/CamConfig_of_07.13.18/Processed_tracks/AllSinglePhaseTracksForMARCC/SmoothTrackswithVel/';
file_name = dir([datapath 'Tracks1*.mat']);
for i = 1 : length(file_name)
    data_name = extractAfter(file_name(i).name, 'Tracks1_');
    track_info = load([datapath, 'Tracks1_', data_name]);
    data = track_info.filter_data;
    track_info = load([datapath, 'Tracks2_', data_name]);
    data = [data; track_info.filter_data];
    track_info = load([datapath, 'Tracks3_', data_name]);
    data = [data; track_info.filter_data];
    save([datapath 'Tracks_' data_name], 'data', '-v7.3');
end

