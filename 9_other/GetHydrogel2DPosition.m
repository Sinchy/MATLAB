for i = 1 : 4
path = [num2str(i) '-1.tiff'];
img1 = imread(path);
img1 = medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(img1))))))));
img1 = wiener2(img1, [5, 5]);
path = [num2str(i) '-2.tiff'];
img2 = imread(path);
 img2 = medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(img2))))))));
 img2 = wiener2(img2, [5, 5]);
img = uint8(double(img1) + double(img2));
imwrite(img, [num2str(i) '.tiff']);
figure
imshow(img);
end