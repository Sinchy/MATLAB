function img2D = ReadImg(filepath, Npixw, Npixh)
fileID = fopen(filepath,'r');
formatspec = '%f,';
img = fscanf(fileID, formatspec);
img2D = reshape(img,[Npixw, Npixh])';
% for i = 1 : 9
%     img2D(i, :) = img((i - 1) * 9 + 1: (i - 1) * 9 + 9);
% end
end

