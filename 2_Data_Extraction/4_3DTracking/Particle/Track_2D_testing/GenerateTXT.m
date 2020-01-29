function GenerateTXT(path, cam, tracks)
sorted_tracks = sortrows(tracks,4);
j = 1;
for i = 5 : 8
    fID = fopen([path 'cam' num2str(cam) 'frame000' num2str(i) '.txt'],'w');
    fmt = '%f,%f,';
    while (sorted_tracks(j, 4) == i) 
        fprintf(fID, fmt, sorted_tracks(j, 2), sorted_tracks(j, 3));
        j = j + 1;
    end
    fclose(fID);
end
end