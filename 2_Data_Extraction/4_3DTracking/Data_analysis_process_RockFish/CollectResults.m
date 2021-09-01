function CollectResults(project_path)
dir_process = [project_path, '/results'];
if ~exist(dir_process, 'dir')
    mkdir(dir_process);
end

end

