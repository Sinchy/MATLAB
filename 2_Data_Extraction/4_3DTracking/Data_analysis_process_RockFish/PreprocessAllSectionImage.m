function PreprocessAllSectionImage(project_path, calibration_file, bubble_image, rotate_image)
d = dir(project_path);
dfolders = d([d(:).isdir]) ;
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..', 'results'}));

start = 1;
if exist([project_path '/Log.txt'], 'file')
    file_ID = fopen([project_path '/Log.txt'], 'r');
    start = fscanf(file_ID,'%d');
    fclose(file_ID);
end

for i = start : size(dfolders, 1)
    dir_process = PreprocessImage([project_path  '/' dfolders(i).name], rotate_image, bubble_image, calibration_file);
    
    if ~bubble_image
        GenerateJobConfiguration([dir_process]);
    else
        GenerateJobConfiguration_bubble([dir_process]);
    end
%     if i > 1
        copyfile([project_path  '/S1/' calibration_file '.txt'], [dir_process]); % for section number smaller than 99
%     end
    file_ID = fopen([project_path '/Log.txt'], 'w');
    fprintf(file_ID, num2str(i));
    fclose(file_ID);
end
end

