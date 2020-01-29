function img = ReadImage(filepath)
fileID = fopen(filepath,'r');
formatspec = '%f,';
img_data = fscanf(fileID, formatspec);
Npixw = 1024; Npixh = 1024;
img = zeros(Npixh, Npixw);
for i = 2 : Npixh
    for j = 2 :  Npixw
        img(i - 1, j - 1) = img_data((i - 1) * Npixw + j);
    end
end
    img = uint8(img);
end

