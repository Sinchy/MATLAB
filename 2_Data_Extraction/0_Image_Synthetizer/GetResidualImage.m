function GetResidualImage(tracks, imagepath, savepath, calibpath, frame_range)
mkdir([imagepath savepath]);
mkdir([imagepath savepath '/cam1']);
mkdir([imagepath savepath '/cam2']);
mkdir([imagepath savepath '/cam3']);
mkdir([imagepath savepath '/cam4']);

for i = frame_range(1) : frame_range(2)
    particles = tracks(tracks(:,4) == i, :);
    I = zeros(1024,1024,4);
    for p = 1 : size(particles, 1)
        Pos3D = particles(p, 1:3);
        I =  Proj2d_IntV2(I, Pos3D, calibpath);
    end
    for j = 1 : 4
        img = imread([imagepath, 'cam' num2str(j) '/cam' num2str(j) 'frame' num2str(i, '%05.0f') '.tif']);
        % get the reproject image
        residual_image = uint8(max(0, double(img) - 2 * I(:, :, j)));
        imwrite(residual_image, [imagepath, savepath '/cam' num2str(j) '/cam' num2str(j) 'frame' num2str(i, '%05.0f') '.tif']);
    end
end
end

