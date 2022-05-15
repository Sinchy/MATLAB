function GenerateBubbleImage(dir, r_range, ncams, rotate_image)
dir_b_ref = [dir '/BubbleRefImages'];
if ~exist(dir_b_ref, 'dir')
    mkdir(dir_b_ref);
end
if ~exist("rotate_image", 'var')
    rotate_image = 0;
end

for cam = 1 : ncams
    imgdir = [dir '/cam_' num2str(cam) '/cam' num2str(cam) 'frame' num2str(1,'%06.0f') '.tif'];
    img = imread(imgdir);
    if rotate_image
        img = img';
    end
    [centers, radius] = imfindcircles(img, r_range);
    figure
    imshow(img);
    viscircles(centers, radius, 'LineWidth', 1);
    n_b = 10;
    [x,y] = GetInputFromImage(n_b);
    b_select = zeros(n_b, 3);
    for i = 1 : n_b
        point = [x(i), y(i)];
        dist = vecnorm(centers - point, 2, 2);
        b_select(i, :) = [centers(dist == min(dist), :), radius(dist == min(dist))];
    end
    viscircles(b_select(:, 1:2), b_select(:, 3), 'Color','yellow');
    size_b = round(max(b_select(:,3))) * 2;
    b_ref = zeros(size_b, size_b);
    for i = 1 : n_b
        % get bubble image
        b_i = img(round(b_select(i, 2) - b_select(i, 3)) : round(b_select(i, 2) + b_select(i, 3)), ...
            round(b_select(i, 1) - b_select(i, 3)) : round(b_select(i, 1) + b_select(i, 3)));
        [nx, ny]  = size(b_i);
        % trim the size when nx ~= ny
        d_b = min(nx, ny);
        if  (nx ~= ny) 
            if (nx > ny) 
                b_i(nx, :) = [];
            else
                b_i(:, ny) = [];
            end
        end
        % remove pixel outside the circle
        r_b = d_b / 2;
        for x = 1 : d_b
            for y = 1 : d_b 
                if ((x - r_b)^2 + (y - r_b) ^ 2 > r_b ^ 2)
                    b_i(x, y) = 0;
                end
            end
        end
        b_i_r = imresize(b_i, [size_b, size_b]);
        b_ref = b_ref + double(b_i_r);
    end
    b_ref = uint8(round(b_ref / n_b));
    if rotate_image
        b_ref = b_ref';
    end
    figure
    imshow(b_ref);
    % output the image
    fileID = fopen([dir_b_ref '/cam' num2str(cam - 1) 'BubbleRefImage.txt'],'w');
    fprintf(fileID, '%d,', b_ref(:));
    fclose(fileID);
end

end

function [X, Y] = GetInputFromImage(n)
times = 0;
X = [];
Y = [];
while times < n
    [x,y,b] = ginput(1); 
    if isempty(b) 
        break;
    elseif b==111 % 'o' to zoom out
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        axis([x-width/2 x+width/2 y-height/2 y+height/2]);
        zoom(1/2);
    elseif b==105 % 'i' to zoom in
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        axis([x-width/2 x+width/2 y-height/2 y+height/2]);
        zoom(2);
    elseif b==30 %move to the top
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        x = (ax(2) + ax(1)) / 2;
        y = (ax(4) + ax(3)) / 2;
        move = -10;
        axis([x - width/2, x + width/2, y - height/2  + move, y + height/2  + move]);
%         zoom(1);
    elseif b==31 %move to the bottom
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        x = (ax(2) + ax(1)) / 2;
        y = (ax(4) + ax(3)) / 2;
        move = 10;
        axis([x - width/2, x + width/2, y - height/2  + move, y + height/2  + move]);
%         zoom(1); 
    elseif b==29 %move to the right
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        x = (ax(2) + ax(1)) / 2;
        y = (ax(4) + ax(3)) / 2;
        move = 10;
        axis([x - width/2 + move, x + width/2 + move, y - height/2, y + height/2]);
        zoom(1);   
    elseif b==28 %move to the left
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        x = (ax(2) + ax(1)) / 2;
        y = (ax(4) + ax(3)) / 2;
        move = -10;
        axis([x - width/2 + move, x + width/2 + move, y - height/2, y + height/2]);
        zoom(1);      
    elseif b == 1
        X=[X;x];
        Y=[Y;y];
        times = times + 1;
        hold on
        plot(x, y, 'y.' );
        text(x,y, num2str(times),'VerticalAlignment','top','HorizontalAlignment','right', 'Color', 'y');
    end
end
end
