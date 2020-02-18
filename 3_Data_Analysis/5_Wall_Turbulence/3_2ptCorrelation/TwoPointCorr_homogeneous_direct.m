% This code performs the Homogeneous Two-Point Correlation using the direct
% correlation between the input variables
%
% Author: Julio Barros
% UIUC - 2011
%
% Version 1.2.3
% Basicaly the same code as the Non-homogeneous
% Normalization is solved!

clear all
close all
clc

if ispc == 1
    slash = '\';
else
    slash ='/';
end

ext = '*.dat';

pathDir = uigetdir('','Select the dir which has the files to be processed');
files = dir(strcat(pathDir,slash,ext));
ResultsFol = strcat(pathDir,slash,'Results_2PointCorr',slash);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% files = files(1:100,:); % DEBUG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Which are the columns that you want to compute the 2 Point Correlation');
disp('Input as a vector format')
disp('In adition, you can organize the variable as you like')
disp('Eg. If you have a Cross-Plane, the phisical U, V and W is, say, 5 4 3,')
disp('so your input will be [5 4 3]')
cols = input('?: ');

disp('Input the yref indices that you would like to perform the 2 point Correlation');
disp('Input as a vector format. Eg: [yref1 yref2 yref3]')
yref_vec = input('?: ');

disp('Choose the appropriate case')
disp('1. 2D or Stereo PIV')
disp('2. 90degree roatated 2D PIV')
disp('3. Cross-Plane Stereo with the original cameras coordinate sys')
type = input('?: ');

savename = input('Type the name of the output file: ','s');
savename = [savename '.dat'];

% Close if there is any open pool
if matlabpool('size') > 0;
    matlabpool close force local
end
% Start the Parallel pools
matlabpool open
cores = matlabpool('size'); % Number of cores availabe in the computer

tstart_p = tic; % Start computing Time

% Split the list of the files into the number of cores
[CompVecList] = DistVecContent(cores,files);

% Number of input Variables
N = length(cols);

% Number of output Variables
NoVar = (N * ( N + 1 ) / 2 );

% Number of Files
NoF = length(files);

% Workk the way through the files in Parallel fashion
for j=1:length(yref_vec)
    disp(['Calculating the 2P Correlation for yref ' num2str(j)])
    yref = yref_vec(j); % Gets the first y_ref
    
    % Start the Parallelization
    spmd
        for i=1:length(CompVecList)
            
            % Open the vector file
            vecfile = CompVecList(i).name;
            pathvecfile = strcat(pathDir,slash,vecfile);
            [nc,I,J,Dx,Dy,A] = matrixCell(pathvecfile);
            
            % Some Initializations
            if i == 1
                X = A{1};
                Y = A{2};
                U = cell(1,N);
                
                Sigma_Y_U_p = cell(1,N);
                for k=1:N
                    Sigma_Y_U_p{k} = zeros(J,2*I-1);
                end
                
                RhoUcell_p = cell(1 ,  N * ( N + 1 ) / 2 );
                for k=1:NoVar
                    RhoUcell_p{k} = zeros(J,2*I-1);
                end
            end
            
            % Put the variables inside Cell U
            for m=1:N
                U{m} = A{cols(m)};
                % Apply some corretions depending on the PIV setup
                if type == 3 && m == N
                    U = fliplr(U);
                end
            end
            
            [RhoUcell , Sigma_Y_U] = HomogeTwoPointCorrFunc(U,yref,type);
            
            for k=1:NoVar
                RhoUcell_p{k} = RhoUcell{k} + RhoUcell_p{k};
            end
            
            for k=1:N
                Sigma_Y_U_p{k} = Sigma_Y_U{k} + Sigma_Y_U_p{k};
            end
        end
    end
    
    % Gather some variables from the first core
    X = X{1};
    Y = Y{1};
    I = I{1};
    J = J{1};
    
    % Initializing the final matricies
    Sigma_Y_U = cell(1,N);
    for k=1:N
        Sigma_Y_U{k} = zeros(J,2*I-1);
    end
    
    RhoUcell = cell(1 ,  N * ( N + 1 ) / 2 );
    for k=1:NoVar
        RhoUcell{k} = zeros(J,2*I-1);
    end
    
    % Gather the correlation from each core
    for c=1:cores
        dummy = RhoUcell_p{c};
        for k=1:NoVar
            RhoUcell{k} = dummy{k} + RhoUcell{k};
        end
    end
    % Gather Sigma from each core
    for c=1:cores
        dummy = Sigma_Y_U_p{c};
        for k=1:N
            Sigma_Y_U{k} = dummy{k} + Sigma_Y_U{k};
        end
    end
    
    % Ensemble Average the Correlation
    for k=1:NoVar
        RhoUcell{k} = RhoUcell{k} / (NoF * (2*I-1));
    end
    
    % Take the rms of the Velocities
    for k=1:N
        Sigma_Y_U{k} = sqrt(max(Sigma_Y_U{k},[],2)/(NoF * (2*I-1)));
        Sigma_Yref{k} = Sigma_Y_U{k}(yref);
    end
    
    % Normalizing the Correlation
    p=1;
    q=1;
    for k=1:NoVar
        for n=1:size(RhoUcell{k},1)
            sigma_uiuj = (Sigma_Yref{p} * Sigma_Y_U{q}(n));
            
            for m=1:size(RhoUcell{k},2)
                %RhoUcell_n{k}(m,:) = RhoUcell{k}(m,:) / (Sigma_Y_U{p} * Sigma_Yref{q});
                RhoUcell_n{k}(n,m) = RhoUcell{k}(n,m) / sigma_uiuj;
            end
        end
        
        if q ~=N
            q = q + 1;
        elseif q == N
            p = p + 1;
            q = p;
        end
    end
    
    disp('Saving the results')
    
    if type == 2
        dx = Dx{1};
        jc = I;
        ic = 2*J-1;
        [~,rx] = xcorr(Y(1,:)); 
        rx = rx.*dx;
        for r=1:jc
            Rx(r,:) = rx;
        end
        ry = X(:,1);
        for r=1:ic
            Ry(:,r) = ry;
        end
    else
        ic = 2*I-1;
        jc = J;
        dx = Dx{1};
        [~,rx] = xcorr(X(1,:));
        rx = rx.*dx;
        for r=1:jc
            Rx(r,:) = rx;
        end
        ry = Y(:,1);
        for r=1:ic
            Ry(:,r) = ry;
        end
    end

    zone = num2str(ry(yref));
    data = mixingCell(ic,jc,Rx,Ry,RhoUcell_n);
    data = sortrows(data , [2 , 1]);
    data = dealNaN(data);
    header = ['ZONE T = "y_ref=' zone 'mm" I =' , num2str(ic) , ' J = ', num2str(jc) , ' F = POINT'];
    
    if j == 1
        saver(ResultsFol,savename,header,data)
    else
        saverappend(ResultsFol,savename,header,data)
    end
end

tstop_p = toc(tstart_p);

disp('')
disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])

% figure
% plot(Y,Sigma_Y_U{1},'kx',Y(yref),Sigma_Yref{1},'ko');
% hold on;
% plot(Y,Sigma_Y_U{2},'rx',Y(yref),Sigma_Yref{2},'ro');
% hold on;
% plot(Y,Sigma_Y_U{3},'bx',Y(yref),Sigma_Yref{3},'bo');
% axis square

figure
for i=1:NoVar
    subplot(ceil(NoVar/2),2,i),[c,h]=contourf(Rx,Ry,RhoUcell_n{i},11);
    set(h,'LevelList',[-0.3:0.025:0.3])
    axis equal
end