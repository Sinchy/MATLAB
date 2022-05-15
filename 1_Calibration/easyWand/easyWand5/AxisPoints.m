function axisPts = AxisPoints(imgdir, r_range, ncams, rotate_image)
%ncams = 3;
if (~exist('rotate_image', 'var'))
    rotate_image = 0;
end

axispoints = zeros(4, ncams * 2);
 for j = 1:ncams
        img0 = imread([imgdir '\S1\Cam' num2str(j) '\cam' num2str(j) 'frame000000.tif']);
        if (rotate_image)
            img0 = img0';
        end  
        img = uint8(255) - img0;
        sensitivity = .95;
        [centers, radii] = imfindcircles(img, r_range, 'Sensitivity', sensitivity);
        n_p = size(centers, 1);
        while n_p < 6
            sensitivity = sensitivity + .01;
            if sensitivity >= 1
                disp('Cannot detect enough circles.')
                return;
            end
            [centers, radii] = imfindcircles(img, r_range, 'Sensitivity', sensitivity);
            n_p = size(centers, 1);
        end
        if n_p > 6
            f = figure;
            f.WindowState = 'maximized';
            imshow(img);
            hold on
            viscircles(centers, radii+5, 'LineWidth', 1);
            for i = 1 : n_p
                plot(centers(i, 1), centers(i, 2), '*');
                text(centers(i, 1), centers(i, 2), num2str(i));
            end
            id_delete = cell2mat(textscan(cell2mat(inputdlg('Delect wrong circles', 'Delect circles')),'%f', 'Delimiter',','));
            centers(id_delete,:) = [];
            radii(id_delete) = [];
            n_p = size(centers, 1);
        end
        % sorts the circle according to the radii
        [radii,index] = sortrows(radii);
        centers = centers(index, :);
        origin(1, :) = (centers(1, :) + centers(2, :))/2;
        origin(2, :) = (centers(3, :) + centers(4, :))/2;
        origin(3, :) = (centers(5, :) + centers(6, :))/2;
        origin = mean(origin);
        f = figure;
        f.WindowState = 'maximized';
%         BW = edge(img, 'log');
        imshow(img);
        hold on
        viscircles(centers, radii+5, 'LineWidth', 1);
        for i = 1 : n_p
            plot(centers(i, 1), centers(i, 2), '*');
            text(centers(i, 1), centers(i, 2), num2str(i));
        end
        plot(origin(1), origin(2), '*')
        text(origin(1) + 10, origin(2) + 10, 'O')
        plot(centers(1:2, 1), centers(1:2, 2), 'b-');
        text(centers(1, 1) + 10, centers(1, 2) + 10, 'X');
        plot(centers(3:4, 1), centers(3:4, 2), 'g-');
        text(centers(3, 1) + 10, centers(3, 2) + 10, 'Y');
        plot(centers(5:6, 1), centers(5:6, 2), 'r-');
        text(centers(5, 1) + 10, centers(5, 2) + 10, 'Z');
        X = str2double(inputdlg('Pick a point in positive X (a point without a hole)?', 'Positive X'));
        Y= str2double(inputdlg('Pick a point in positive Y(a point without a hole)?', 'Positive Y'));
        Z = str2double(inputdlg('Pick a point in positive Z(a point without a hole)?', 'Positive Z'));
%         [~,  Z] = min(centers(5:6, 2));
%         Z = Z + 4;
        axispoints(1, (j - 1) * 2 + 1 :  (j - 1) * 2 + 2) = origin;
        axispoints(2, (j - 1) * 2 + 1:  (j - 1) * 2 + 2) = centers(X, :);
        axispoints(3, (j - 1) * 2 + 1:  (j - 1) * 2 + 2) = centers(Y, :);
        axispoints(4, (j - 1) * 2 + 1:  (j - 1) * 2 + 2) = centers(Z, :);
 end
 axisPts = axispoints;
end

