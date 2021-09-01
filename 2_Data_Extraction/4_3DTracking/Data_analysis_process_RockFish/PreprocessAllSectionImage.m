function PreprocessAllSectionImage(project_path, calibration_file)
d = dir(project_path);
dfolders = d([d(:).isdir]) ;
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..', 'results'}));

for i = 1 : size(dfolders, 1)
    dir_process = PreprocessImage([project_path  '/' dfolders(i).name], calibration_file);
    GenerateJobConfiguration([dir_process]);
    if i > 1
        copyfile([project_path  '/S01/' calibration_file '.txt'], [dir_process]); % for section number smaller than 99
    end
end
end

