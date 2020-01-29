filepath = '/home/tanshiyong/Documents/Data/Single-Phase/SD50000/Residual_image_code/';

for i = 101:150
    for j = 1:4
        img = ReadImage([filepath 'cam' num2str(j) '/frame' num2str(i) '.txt']);
        imwrite(img, [filepath 'cam' num2str(j) '/cam' num2str(j) 'frame' num2str(i, '%05.0f'), '.tif']);
    end
end