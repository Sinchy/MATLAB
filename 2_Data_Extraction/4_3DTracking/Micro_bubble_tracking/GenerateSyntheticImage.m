function GenerateSyntheticImage(data, dp, save_img_file, camParaCalib)
totalframe = max(data(:,4));
for i = 1 : size(camParaCalib, 1)
    cam(i) = Camera(camParaCalib(i));
    mkdir([save_img_file, 'cam_' num2str(i)]);
end

for i = 1 : 1: totalframe
    frame_part = data(data(:,4) == i, [1:3 5]);
    [~, id] = ismember(frame_part(:, 4), dp);
    frame_part(:, 4) = dp(id, 2);
%         %repeat the particle to fill the whole range
%     data2 = [];
% %     rotate_index = 1;
%     for dx = [-80 -40 0 40 80]
%         for dy = [-80 -40 0 40 80]
%             data3 = frame_part;
%             data3(:,1) = data3(:, 1) + dx;
%             data3(:,2) = data3(:, 2) + dy;
%             data2 = [data2; data3];
%         end
%     end
%     frame_part = data2;  
%     clear data2;
    
    num_part = size(frame_part, 1);
    img = uint8(zeros(4, camParaCalib(1).Npixh, camParaCalib(1).Npixw));
    for j = 1 : num_part
        for k = 1 : size(camParaCalib, 1)
            img(k, :, :) = ParticleProjection(reshape(img(k, :, :), [camParaCalib(1).Npixh, camParaCalib(1).Npixw]), ...
                cam(k), frame_part(j, 1:3), frame_part(j, 4));
        end
    end
    for k = 1 : size(camParaCalib, 1)
        imwrite(reshape(img(k,:,:), [camParaCalib(1).Npixh, camParaCalib(1).Npixw]),...
            [save_img_file 'cam_' num2str(k) '/' 'cam' num2str(k) 'frame' num2str(i, '%06.0f') '.tif']);
    end
end

end

