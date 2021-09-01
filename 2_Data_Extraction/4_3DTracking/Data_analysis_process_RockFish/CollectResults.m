function CollectResults(project_path)
dir_process = [project_path, '/results'];
if ~exist(dir_process, 'dir')
    mkdir(dir_process);
end

dfolders = d([project_path(:).isdir]) ;
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..', 'results'}));

for i = 1 : size(dfolders, 1)
    if exist([project_path '/' dfolders(i) '/Tracks'], 'dir')
        if ~exit([dir_process '/' dfolders(i)], 'dir')
            mkdir([dir_process '/' dfolders(i)]);
        end
        copyfile([project_path '/' dfolders(i) '/Tracks'], [dir_process '/' dfolders(i)]);
    end
end

end

