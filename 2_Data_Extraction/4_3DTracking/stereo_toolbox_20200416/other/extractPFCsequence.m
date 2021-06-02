function extractPFCsequence()
% This function extracts the sequence files of 4 camera-files into our
% common file/folder structure

[file1, path1] = uigetfile('*.seq', 'Choose camera 1 sequence file');
if file1 == 0
    error('Sequence selection aborted.');
    return;
end
cd(path1);

[file2, path2] = uigetfile('*.seq', 'Choose camera 2 sequence file');
if file2 == 0
    error('Sequence selection aborted.');
    return;
end


[file3, path3] = uigetfile('*.seq', 'Choose camera 3 sequence file');
if file3 == 0
    error('Sequence selection aborted.');
    return;
end


[file4, path4] = uigetfile('*.seq', 'Choose camera 4 sequence file');
if file4 == 0
    error('Sequence selection aborted.');
    return;
end

path_out = uigetdir('./', 'Choose directory. A folder with the sequence name will be created.');

% check if all sequence names are the same
seqName1 = file1(1:end-4);
seqName2 = file2(1:end-4);
seqName3 = file3(1:end-4);
seqName4 = file4(1:end-4);

if ~( strcmp(seqName1, seqName2) && strcmp(seqName2, seqName3) && strcmp(seqName3, seqName4) )
    warning('Sequence files seem to be from different parabolas!');
end

mkdir(fullfile(path_out, seqName1));
mkdir(fullfile(path_out, seqName1, 'cam1/'));
mkdir(fullfile(path_out, seqName2, 'cam2/'));
mkdir(fullfile(path_out, seqName3, 'cam3/'));
mkdir(fullfile(path_out, seqName4, 'cam4/'));

fr_start = input('first frame to extract: ');
fr_end = input('last frame to extract: ');

disp('Extracting Sequences:');
fullfile(path_out, seqName1, 'cam1')
Norpix2MATLAB(fullfile(path1, file1), fullfile(path_out, seqName1, 'cam1'),0, [fr_start fr_end]);
Norpix2MATLAB(fullfile(path2, file2), fullfile(path_out, seqName2, 'cam2'),0, [fr_start fr_end]);
Norpix2MATLAB(fullfile(path3, file3), fullfile(path_out, seqName3, 'cam3'),0, [fr_start fr_end]);
Norpix2MATLAB(fullfile(path4, file4), fullfile(path_out, seqName4, 'cam4'),0, [fr_start fr_end]);

disp('Flipping Images (left-right):');

cd(fullfile(path_out, seqName1, 'cam1'));
flipImages('lr');
cd(fullfile(path_out, seqName2, 'cam2'));
flipImages('lr');
cd(fullfile(path_out, seqName3, 'cam3'));
flipImages('lr');
cd(fullfile(path_out, seqName4, 'cam4'));
flipImages('lr');

end

