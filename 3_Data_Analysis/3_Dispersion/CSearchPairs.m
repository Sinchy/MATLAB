function CSearchPairs(data_path, bin, disp_rate)
file = matfile(data_path);

tracks = file.filter_data(:, 1:5);
% get track info
[trackID, start_index, ic] = unique(tracks(:,5) );
a_counts = accumarray(ic,1);
tr_info = [trackID, tracks(start_index, 4), a_counts];

% sort track according to frame
tracks = sortrows(tracks, 4);
[frame_no, start_index, ic] = unique(tracks(:,4) );
a_counts = accumarray(ic,1);
frame_info = [frame_no, start_index - 1, a_counts]; % start_index - 1 to adjust index in C

% minimum pair length
t0 = CalT0(disp_rate, mean(bin, 2));
pair_len = t0 * 4000 * 10;
pair_len(pair_len>1000) = 1000;

% save path
pos = strfind(data_path, '\');
save_path = [data_path(1:pos(end))  'pairs\data.mat'];
mkdir([data_path(1:pos(end))  'pairs']);
save(save_path, 'tracks', 'bin', 'tr_info', 'frame_info', 'pair_len', '-v7.3');
clear tracks bin tr_info frame_info pair_len;
tic
system(['cd D:\0.Code\MATLAB\3_Data_Analysis\3_Dispersion\CDispersion\x64\Release && .\CDispersion.exe ' save_path]);
toc
delete(save_path)
end

