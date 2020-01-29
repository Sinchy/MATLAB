
function GenerateBlurImage(data, save_img_file, calib_file, DOF)
% get the particles outside the view area
load(calib_file);
% data = data(:,[3 2 1 4 5]);
% data(:, 1:3) = data(:, 1:3) * 60 / max(data(:, 1));
% data = data(abs(data(:, 1)) > 20 | abs(data(:, 2)) > 20 | abs(data(:, 3)) > 20, :);


totalframe = max(data(:,4));
for i = 1 : 4
    mkdir([save_img_file, 'cam' num2str(i)]);
end

rotate_array = zeros(8, 3, 3);
for i = 1 : 8
    rotate_array(i, :, :) = Rotation3D(rand(1,3) * 2 * pi);
end


for i = 1 : 1: totalframe
    frame_part = data(data(:,4) == i, 1:3);
    %repeat the particle to fill the whole range
%     data2 = [];
%     rotate_index = 1;
%     for dx = [-40 0 40]
%         for dy = [-40 0 40]
% %             if dx == 0 && dy == 0
% %                 continue;
% %             end
%             if dx == 0 && dy == 0
%                 data3 = frame_part(:, 1:3);
%             else
%                 data3 = frame_part(:, 1:3); %* reshape(rotate_array(rotate_index, :, :), 3, 3); % rotate it randomly
%                 rotate_index = rotate_index + 1;
%             end
%             data3(:,1) = data3(:, 1) + dx;
%             data3(:,2) = data3(:, 2) + dy;
%             data2 = [data2; data3];
%         end
%     end
%     frame_part = data2;  
    clear data2;
%     frame_part = [frame_part; frame_part * Rotation3D(rand(1,3) * 2 * pi)];
%     frame_part = [frame_part; frame_part * Rotation3D(rand(1,3) * 2 * pi)];
%     frame_part = frame_part * 40 / 20;
%     frame_part = frame_part(abs(frame_part(:, 1)) > 20 | abs(frame_part(:, 2)) > 20 | abs(frame_part(:, 3)) > 20, :);
    num_part = size(frame_part, 1);
    img = uint8(zeros(4, 1024, 1024));
%     for cam = 1 : 4
%         img(cam, :, :) = imread([img_file 'cam' num2str(cam) '/cam' num2str(cam) 'frame' num2str(i, '%05.0f') '.tif']);
%     end
    for j = 1 : num_part
        img = GenerateBlurParticle(img, frame_part(j, 1:3), camParaCalib, DOF);
    end
    for cam = 1 : 4
        imwrite(reshape(img(cam,:,:), 1024, 1024),[save_img_file 'cam' num2str(cam) '/' 'cam' num2str(cam) 'frame' num2str(i, '%05.0f') '.tif']);
    end
end
end


function R = Rotation3D(angle)
    a = angle(1); b = angle(2); c = angle(3);
    R = [ cos(a) * cos(b), sin(a) * cos(b), -sin(b); ...
        -sin(a) * cos(c) + cos(a) * sin(b) * cos(c), cos(a) * cos(c) + sin(a) * sin(b) * sin(c), cos(b) * sin(c);...
        sin(a) * sin(c) + cos(a) * sin(b) * cos(c), -cos(a) * sin(c) + sin(a) * sin(b) * cos(c), cos(b) * cos(c)];
end
