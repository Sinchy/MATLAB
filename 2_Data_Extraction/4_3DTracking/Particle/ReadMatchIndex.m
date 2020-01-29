function match = ReadMatchIndex(filepath)
fileID = fopen(filepath,'r');
formatspec = '%f,';
match_vec = fscanf(fileID, formatspec);
l = length(match_vec);
for i = 1 : l / 4
    match(i, :) = match_vec((i - 1) * 2 + 1: (i - 1) * 2 + 4);
end
end

