for i = 1 : 3000
    img = imread(['E:\VONSET\20210524\T4\cam_1\cam1frame' num2str(i, '%06.0f') '.tif']);
    position2D = Get2DPosOnImage(img);
    num_2D(i) = size(position2D, 1);
end