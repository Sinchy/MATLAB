function CSearchPairs(tracks, bin, disp_rate, frame_rate, max_pair_len, data_path)
% file = matfile(data_path);
% 
% tracks = file.tracks(:, 1:5);
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
pair_len = t0 * frame_rate * 2;
pair_len(pair_len>max_pair_len / 2) = round(max_pair_len / 2);
bin = bin * 1e3; % m to mm
% save path
% pos = strfind(data_path, '\');
save_path = [data_path  '\pairs\data.mat'];
mkdir([data_path  'pairs']);
save(save_path, 'tracks', 'bin', 'tr_info', 'frame_info', 'pair_len', '-v7.3');
clear tracks bin tr_info frame_info pair_len;
tic
system(['cd D:\0.Code\MATLAB\3_Data_Analysis\3_Dispersion\CDispersion\x64\Release && .\CDispersion.exe ' save_path]);
toc
delete(save_path)
end

