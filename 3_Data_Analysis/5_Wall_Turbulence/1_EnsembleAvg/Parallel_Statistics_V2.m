% Parallel_Statistics
% Function to compute the all Single Point Statistics
%
% Author: Julio Barros - UIUC 2011
% version: 2.2
% modified for parallel computing by Taehoon Kim - UIUC 2016

clear all
close all
clc

%%%%%%%%%%%%%
% USER INPUTS
%%%%%%%%%%%%%

%ext = input('Type, the extention of the files to be processed (eg: *.vec): ','s');
type = input('Type if it is 2D, Stereo, 3D: ','s');

if strcmp(type,'2D') == 1
    ext = '*.dat';
elseif strcmp(type,'Stereo') == 1
    ext = '*.v3d';
elseif strcmp(type,'3D') == 1
    ext = '*.v3v';
else
    disp('You did not choose the correct option')
    
end

% Dealing with slash on all OS
if ispc == 1
    slash = '\';
else
    slash = '/';
end

pathDir = uigetdir('','Select the dir which has the files to be processed');
files = dir(strcat(pathDir,slash,ext));
if isempty(files) == 1
    ext = '*R.vec';
    files = dir(strcat(pathDir,slash,ext));
end
ResultsFol = strcat(pathDir,slash,'Results',slash);
%%%%%%%%%%%%%%%%%%%%%%
files = files(1:500); %DEBUG PURPOSE
%%%%%%%%%%%%%%%%%%%%%%

disp('Do you want to specify a Region of interest?');
ROI = input('y , n?: ','s');
if strcmp(ROI,'y')==1 || strcmp(ROI,'Y')==1
    disp('Format: [left right bottom top]')
    crop = input('Type the ROI: ');
else
    crop = [1 1 1 1];
end

disp('Do you want to save the Fluctuation files?')
flucask = input('y or n?: ','s');

disp('Which direction do you want to caculate the line average?')
disp('1. Horizintal (across rows)')
disp('2. Vertical (across columns)')
direction = input(':? ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close if there is any open pool
query = isempty(gcp('nocreate'));

if query == 0;
    delete(gcp('nocreate'))
end
% Start the Parallel pools
parpool('local')

poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    cores = 0;
else
    cores = poolobj.NumWorkers; % Number of cores availabe in the computer
end

tstart_p = tic; % Start computing Time

% Split the list of the files into the number of cores
[CompVecList] = DistVecContent(cores,files);

% tanshiyong: the unit is pixel/delta t, delta t is the time inteval
% between two frames.
disp('Calculating the Ensemble Average')
[AxisCell,Ucell,Lciavg,Omega_avg,CHCavg] = ensembleAverage(CompVecList,cores,crop,pathDir);

disp('')
disp('Calculating the Reynolds Stresses')
[uiujCell,lci,omega] = ReynoldsStress(CompVecList,cores,Ucell,Lciavg,Omega_avg,crop,pathDir,flucask);

% Determine the size of the final variables
[J,I] = size(Ucell{1});
N = length(Ucell);

% Putting all the variables in a Tecplot form
vel = mixingCell_Stat(I,J,AxisCell,Ucell,uiujCell,Lciavg,Omega_avg,lci,omega,CHCavg);
vel = dealNaN(vel);
vel = sortrows(vel, [2 , 1]);

if N == 2
    TecplotHeader = ['VARIABLES="x", "y",'...
        '"<math>a</math>U<math>q</math>", '...
        '"<math>a</math>V<math>q</math>", '...
        '"<math>a</math>u<sup>2</sup><math>q</math>", '...
        '"<math>a</math>uv<math>q</math>", '...
        '"<math>a</math>v<sup>2</sup><math>q</math>", '...
        '"<math>a</math>Lci<math>q</math>", '...
        '"<math>a</math>Omega<math>q</math>", '...
        '"<math>a</math>lci<sub>rms</sub><math>q</math>", '...
        '"<math>a</math>omega<sub>rms</sub><math>q</math>", '...
        '"CHC" ' ...
        'ZONE I=' num2str(I) ', J=' num2str(J) ', K=1, F=POINT'];
elseif N == 3
    TecplotHeader = ['VARIABLES="x", "y", "z",'...
        '"<math>a</math>U<math>q</math>", '...
        '"<math>a</math>V<math>q</math>", '...
        '"<math>a</math>W<math>q</math>", '...
        '"<math>a</math>u<sup>2</sup><math>q</math>", '...
        '"<math>a</math>uv<math>q</math>", '...
        '"<math>a</math>uw<math>q</math>", '...
        '"<math>a</math>v<sup>2</sup><math>q</math>", '...
        '"<math>a</math>vw<math>q</math>", '...
        '"<math>a</math>w<sup>2</sup><math>q</math>", '...
        '"<math>a</math>Lci<math>q</math>", '...
        '"<math>a</math>Omega<math>q</math>", '...
        '"<math>a</math>lci<sub>rms</sub><math>q</math>", '...
        '"<math>a</math>omega<sub>rms</sub><math>q</math>", '...
        '"CHC" ' ...
        'ZONE I=' num2str(I) ', J=' num2str(J) ', K=1, F=POINT'];
end

saver(ResultsFol,'EnsembleAverage_v2_2.dat',TecplotHeader,vel);

% Calculates the Line Average
if direction == 1
    if N == 2
        x = AxisCell{1}(1,:);
        U = nanmean(Ucell{1},direction);
        V = nanmean(Ucell{2},direction);
        uu = nanmean(uiujCell{1},direction);
        uv = nanmean(uiujCell{2},direction);
        vv = nanmean(uiujCell{3},direction);
        Lcil = nanmean(Lciavg,direction);
        Omegal = nanmean(Omega_avg,direction);
        lcil = nanmean(lci,direction);
        omegal = nanmean(omega,direction);
        tj = I;
        
        TecplotHeader2 = ['VARIABLES="x",'...
            '"<math>a</math>U<math>q</math>", '...
            '"<math>a</math>V<math>q</math>", '...
            '"<math>a</math>u<sup>2</sup><math>q</math>", '...
            '"<math>a</math>uv<math>q</math>", '...
            '"<math>a</math>v<sup>2</sup><math>q</math>", '...
            '"<math>a</math>Lci<math>q</math>", '...
            '"<math>a</math>Omega<math>q</math>", '...
            '"<math>a</math>lci<sub>rms</sub><math>q</math>", '...
            '"<math>a</math>omega<sub>rms</sub><math>q</math>", '...
            'ZONE I=1, J=' num2str(tj) ', K=1, F=POINT'];
        
        vel_l = [x' U' V' uu' uv' vv' Lcil' Omegal' lcil' omegal'];
   
    elseif N == 3
        
        x = AxisCell{1}(1,:);
        U = nanmean(Ucell{1},direction);
        V = nanmean(Ucell{2},direction);
        W = nanmean(Ucell{3},direction);
        uu = nanmean(uiujCell{1},direction);
        uv = nanmean(uiujCell{2},direction);
        uw = nanmean(uiujCell{3},direction);
        vv = nanmean(uiujCell{4},direction);
        vw = nanmean(uiujCell{5},direction);
        ww = nanmean(uiujCell{6},direction);
        Lcil = nanmean(Lciavg,direction);
        Omegal = nanmean(Omega_avg,direction);
        lcil = nanmean(lci,direction);
        omegal = nanmean(omega,direction);
        tj = I;
        
        TecplotHeader2 = ['VARIABLES="y", '...
            '"<math>a</math>U<math>q</math>", '...
            '"<math>a</math>V<math>q</math>", '...
            '"<math>a</math>W<math>q</math>", '...
            '"<math>a</math>u<sup>2</sup><math>q</math>", '...
            '"<math>a</math>uv<math>q</math>", '...
            '"<math>a</math>uw<math>q</math>", '...
            '"<math>a</math>v<sup>2</sup><math>q</math>", '...
            '"<math>a</math>vw<math>q</math>", '...
            '"<math>a</math>w<sup>2</sup><math>q</math>", '...
            '"<math>a</math>Lci<math>q</math>", '...
            '"<math>a</math>Omega<math>q</math>", '...
            '"<math>a</math>lci<sub>rms</sub><math>q</math>", '...
            '"<math>a</math>omega<sub>rms</sub><math>q</math>", '...
            'ZONE I=1, J=' num2str(J) ', K=1, F=POINT'];
        
        vel_l = [x' U' V' W' uu' uv' uw' vv' vw' ww' Lcil' Omegal' lcil' omegal'];
        
    end
    
    
elseif direction == 2
    
    if N == 2
        y = AxisCell{2}(:,1);
        U = nanmean(Ucell{1},direction);
        V = nanmean(Ucell{2},direction);
        uu = nanmean(uiujCell{1},direction);
        uv = nanmean(uiujCell{2},direction);
        vv = nanmean(uiujCell{3},direction);
        Lcil = nanmean(Lciavg,direction);
        Omegal = nanmean(Omega_avg,direction);
        lcil = nanmean(lci,direction);
        omegal = nanmean(omega,direction);
        tj = J;
        
        TecplotHeader2 = ['VARIABLES="y",'...
            '"<math>a</math>U<math>q</math>", '...
            '"<math>a</math>V<math>q</math>", '...
            '"<math>a</math>u<sup>2</sup><math>q</math>", '...
            '"<math>a</math>uv<math>q</math>", '...
            '"<math>a</math>v<sup>2</sup><math>q</math>", '...
            '"<math>a</math>Lci<math>q</math>", '...
            '"<math>a</math>Omega<math>q</math>", '...
            '"<math>a</math>lci<sub>rms</sub><math>q</math>", '...
            '"<math>a</math>omega<sub>rms</sub><math>q</math>", '...
            'ZONE I=1, J=' num2str(J) ', K=1, F=POINT'];
        
        vel_l = [y U V uu uv vv Lcil Omegal lcil omegal];
        
    elseif N == 3
        y = AxisCell{2}(:,1);
        U = nanmean(Ucell{1},direction);
        V = nanmean(Ucell{2},direction);
        W = nanmean(Ucell{3},direction);
        uu = nanmean(uiujCell{1},direction);
        uv = nanmean(uiujCell{2},direction);
        uw = nanmean(uiujCell{3},direction);
        vv = nanmean(uiujCell{4},direction);
        vw = nanmean(uiujCell{5},direction);
        ww = nanmean(uiujCell{6},direction);
        Lcil = nanmean(Lciavg,direction);
        Omegal = nanmean(Omega_avg,direction);
        lcil = nanmean(lci,direction);
        omegal = nanmean(omega,direction);
        tj = J;
        
        TecplotHeader2 = ['VARIABLES="y" '...
            '"<math>a</math>U<math>q</math>", '...
            '"<math>a</math>V<math>q</math>", '...
            '"<math>a</math>W<math>q</math>", '...
            '"<math>a</math>u<sup>2</sup><math>q</math>", '...
            '"<math>a</math>uv<math>q</math>", '...
            '"<math>a</math>uw<math>q</math>", '...
            '"<math>a</math>v<sup>2</sup><math>q</math>", '...
            '"<math>a</math>vw<math>q</math>", '...
            '"<math>a</math>w<sup>2</sup><math>q</math>", '...
            '"<math>a</math>Lci<math>q</math>", '...
            '"<math>a</math>Omega<math>q</math>", '...
            '"<math>a</math>lci<sub>rms</sub><math>q</math>", '...
            '"<math>a</math>omega<sub>rms</sub><math>q</math>", '...
            'ZONE I=1, J=' num2str(J) ', K=1, F=POINT'];
        
        vel_l = [y U V W uu uv uw vv vw ww Lcil Omegal lcil omegal];
    end
    
end
vel_l = dealNaN(vel_l);
vel_l = sortrows(vel_l,1);

% Save the file
saver(ResultsFol,'Line_Average_V2_2.dat',TecplotHeader2,vel_l);

tstop_p = toc(tstart_p);

disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])

% Close Matlab Pool
% matlabpool close