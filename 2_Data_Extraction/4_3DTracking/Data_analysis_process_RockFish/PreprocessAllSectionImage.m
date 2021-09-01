function PreprocessAllSectionImage(project_path, calibration_file)
d = dir(project_path);
dfolders = d([d(:).isdir]) ;
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..', 'results'}));

for i = 1 : size(dfolders, 1)
    PreprocessImage([project_path  '/' dfolders(i).name], calibration_file);
    GenerateJobConfiguration([project_path  '/' dfolders(i).name]);
    if i > 1
        copyfile([project_path  '/S1/' calibration_file '.txt'], [project_path  '/' dfolders(i).name]);
    end
end
end
