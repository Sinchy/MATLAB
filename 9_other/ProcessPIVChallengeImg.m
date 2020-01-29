function ProcessPIVChallengeImg(path)
for i = 1 : 4
    for j = 1 : 51
        img = imread([path '/cam' num2str(i) '/cam' num2str(i) 'frame' num2str(j, '%05.0f') '.tif']);
        img8 = uint8(img/2^8);
        img8 = imadjust(img8,[0 0.06]);
        imwrite(img8, [path '/cam' num2str(i) '/cam' num2str(i) 'frame' num2str(j, '%05.0f') '.tif']);
    end
end
end

