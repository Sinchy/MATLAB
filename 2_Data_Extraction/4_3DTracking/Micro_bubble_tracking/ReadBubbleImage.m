function img = ReadBubbleImage(filepath, dim)
% particles = frame1Loop0New;
fileID = fopen(filepath,'r');
formatspec = '%f,';
img = fscanf(fileID, formatspec);
if ~exist('dim', 'var')
img = reshape(img, [length(img)^.5 length(img)^.5]);
else
    img = reshape(img, dim);
end
% img = reshape(img, [800 1280]);
img = uint8(img);
max_int = max(img(:))
figure
imshow(img)
fclose(fileID)
end

