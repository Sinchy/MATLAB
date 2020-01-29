load_filename = {'allcams_3D0.1_2D0.1_new.mat', '123cams_3D0.03_2D0.03_new.mat'...
    '124cams_3D0.03_2D0.03_new.mat', '134cams_3D0.03_2D0.03_new.mat', '234cams_3D0.03_2D0.03_new.mat'};

rename = [1234, 123, 124, 134, 234];
frames = 200;

for i = 1:5
    load(load_filename{i});
    cam = cell(1,1);
    for frame = 1:frames
        if (numel(eval(['frame' num2str(frame)])) ~= 0)
            if (rename(i) == 1234 || rename(i) == 123) 
            elseif (rename(i) == 234) 
                eval(['frame' num2str(frame) '(:,[5:7 4]) = frame' num2str(frame) '(:,4:7);']); 
            elseif (rename(i) == 134)
                eval(['frame' num2str(frame) '(:,[6:7 5]) = frame' num2str(frame) '(:,5:7);']); 
            elseif (rename(i) == 124)
                eval(['frame' num2str(frame) '(:,[7 6]) = frame' num2str(frame) '(:,6:7);']); 
            end  
        end
        eval(['cam{frame,1} = frame' num2str(frame) ';']);
    end
    eval(['cam_' num2str(rename(i)) ' = cam;']);
end

save all_camCombinations_2Dtracks.mat cam_1234 cam_123 cam_124 cam_134 cam_234
    