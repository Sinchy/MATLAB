function DynamicProjection(path, track, camParaCalib)
cam = 1;
minframe = track(1, 4);
maxframe = track(end, 4);

figure;

for i = minframe : maxframe
    for cam = 1 : 4
        subplot(1,4,cam);
        center_a = round(calibProj_Tsai(camParaCalib(cam), track(:,1:3)));

        xrange = [min(center_a(:,1)) max(center_a(:,1))];
        yrange = [min(center_a(:,2)) max(center_a(:,2))];
        img = imread([path 'cam' num2str(cam) '/cam' num2str(cam) 'frame' num2str(i,'%06.0f') '.tif']);
        [yp, xp] = size(img);
        x_start = xrange(1) - 4; y_start = yrange(1) - 4;
        if (xrange(2) < 0 | yrange(2) < 0 | xrange(1) > xp | yrange(1) > yp) 
            continue;
        end
         img = img(max(y_start, 1): min(yrange(2) + 4, yp), max(x_start, 1): min(xrange(2) + 4, xp));
        center = calibProj_Tsai(camParaCalib(cam), track(i - minframe + 1,1:3));
%         img = img(max(center(2) - 20, 1): min(center(2) + 20, yp), max(center(1) - 20, 1): min(center(1) + 20, xp));
        hold off
        imshow(img);
        hold on
         plot(center(1) - x_start + 1, center(2) - y_start + 1, 'y.');
%         plot(20,20, 'y.');
    end
    pause(1);
end

end

