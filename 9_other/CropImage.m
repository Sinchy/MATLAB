function CropImage(path)
for i = 1 : 4
    for j = 1 : 51
        img = imread([path '/cam' num2str(i) '_0/cam' num2str(i) 'frame' num2str(j, '%05.0f') '.tif']);
        img8 = img(:, 1505:3008);
        imwrite(img8, [path '/cam' num2str(i) '/cam' num2str(i) 'frame' num2str(j, '%05.0f') '.tif']);
    end
end
end

