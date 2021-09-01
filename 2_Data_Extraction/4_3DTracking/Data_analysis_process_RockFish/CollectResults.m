function CollectResults(project_path)
dir_process = [project_path, '/results'];
if ~exist(dir_process, 'dir')
    mkdir(dir_process);
end

d = dir(project_path);
dfolders = d([d(:).isdir]) ;
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..', 'results'}));

for i = 1 : size(dfolders, 1)
    if exist([project_path '/' dfolders(i).name '/Tracks'], 'dir')
        if ~exist([dir_process '/' dfolders(i).name], 'dir')
            mkdir([dir_process '/' dfolders(i).name]);
        end
        copyfile([project_path '/' dfolders(i).name '/Tracks'], [dir_process '/' dfolders(i).name '/Tracks']);
    end
end

end

