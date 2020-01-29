function TracksToTXT(filepath, tracks)
fileID = fopen([filepath 'ActiveLongTracks4.txt'],'w');
formatspec = '%f,';
tracks = tracks(:, [5 4 1 2 3]);

[C,~,ic] = unique(tracks(:,1));
a_counts = accumarray(ic,1);
trID_long = C(a_counts == 4);
tracks_long = tracks(ismember(tracks(:,1), trID_long), :);

for i = 1 : size(tracks_long, 1)
    fprintf(fileID, formatspec, tracks_long(i, :));
end
fclose(fileID);

fileID = fopen([filepath 'ActiveShortTracks4.txt'],'w');
trID_short = C(a_counts < 4);
tracks_short = tracks(ismember(tracks(:,1), trID_short), :);
for i = 1 : size(trID_short)
   track_one = tracks_short(tracks_short(:, 1) == trID_short(i), :);
   if max(track_one(:, 2)) < 4 
       continue;
   end
   for j = 1 : size(track_one, 1)
       fprintf(fileID, formatspec, track_one(j, :));
   end
end
end

