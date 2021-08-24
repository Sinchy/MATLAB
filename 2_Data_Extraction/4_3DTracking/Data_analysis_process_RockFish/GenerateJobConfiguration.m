function GenerateJobConfiguration(file_path, file_name)
fileID = fopen([file_path '/' file_name '.sh'],'w');
fprintf(fileID, '#!/bin/bash -l\n');
fprintf(fileID,['#SBATCH --job-name=' file_name '\n']);

txt = ['#SBATCH --time=72:00:00\n' ...
'#SBATCH --partition=defq\n' ...
'#SBATCH --nodes=1\n' ...
'#SBATCH --ntasks-per-node=24\n' ...
'#SBATCH --mail-type=end\n' ...
'#SBATCH --mail-user=stan26@jhu.edu\n' ...
'\n'...
'export OMP_NUM_THREADS=24\n'];
fprintf(fileID,txt);

fprintf(fileID, ['cd ' file_path '\n']);
txt = [ '/home/stan26/data_rni2/Code/OpenLPT_Shake-The-Box/VisualStudio/ShakeTheBox/ShakeTheBox/Release/ShakeTheBox trackingconfig1.txt > result.txt << EOF\n' ...
'0\n' ...
'0\n' ...
'EOF\n' ];
fprintf(fileID,txt);
fclose(fileID);
end

