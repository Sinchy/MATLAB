clear all
% close all
clc

%%%%%%%%%%%%%%%
% USER INPUTS %
%%%%%%%%%%%%%%%

if ispc == 1
    slash = '\';
else
    slash = '/';
end

path_stack = uigetdir('','Select the folder where the stacked files are located');
files_stack = dir([path_stack slash '*BackSub*.TIF']);

path_back = uigetdir('','Select the folder where the background images are located');
files_back = dir([path_back slash 'Avged2*.TIF']);

nChunk = length(files_stack);
%%

tstart_p = tic; % Start computing Time
wb = waitbar(0, '','Name','Computing particle trajectories');

for i = 5 : length(files_stack)
    File_stack = files_stack(i).name;
    File_back = files_back(1).name;

    waitbar(i/nChunk,wb,[num2str(i),'/',num2str(nChunk)])
      
    [vtracks,ntracks,meanlength,rmslength] = PredictiveTracker([path_stack slash File_stack], 7000, 13, [path_back slash File_back], 1, -1, 0);
%     [vtracks,ntracks,meanlength,rmslength] = PredictiveTracker([path_stack slash File_stack], 7680, 4, [path_back slash File_back], 1, 0, 1);

    tracks = restructure_2Dtracks(vtracks);
    save([path_stack slash 'Data' num2str(i) '_For_7000_13_2_-1_1.mat'],'vtracks','ntracks','meanlength','rmslength','tracks'); 
    close all
end
close(wb)

tstop_p = toc(tstart_p);
disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])