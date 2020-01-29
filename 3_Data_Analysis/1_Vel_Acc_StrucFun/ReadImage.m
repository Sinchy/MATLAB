function img_adjust = ReadImage(filepath)
fileID = fopen(filepath,'r');
formatspec = '%f,';
img_data = fscanf(fileID, formatspec);
Img = uint8(reshape(img_data, 1024, 1024))';
img_adjust = uint8(zeros(1024,1024));
img_adjust(1:end-1, 1:end-1) = Img(2:end,2:end);
end

