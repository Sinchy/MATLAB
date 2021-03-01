% This code performs the Two Point Correlation using the direct
% correlation between the input variables
%
% Author: Julio Barros
% UIUC - 2011
%
% Modifed by Taehoon Kim UIUC 2016
%
% Correction: -add cases : 2D, Stereo, Rotated Field
%             -also change the flipping of U
%             -add change of xref,yref for rotated/unrotated
%             -add change of 'Normalizing the correlation' for rotated/unrotated
%             -add axis values, Rx and Ry
%             -add change of rms velocity (direction 1-> xrefc, direction 2-> yrefc)
% I guess normalization is correct
%             -Some improvements in terms of the organization of the variables from user
%             input

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
% files = files(1:250,:); % DEBUG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Which are the columns that you want to compute the 2 Point Correlation');
disp('Input as a vector format')
disp('In adition, you can organize the variable as you like')
disp('Eg. If you have a Cross-Plane, the phisical U, V and W is, say, 5 4 3,')
disp('so your input will be [5 4 3]')
cols = input('?: ');

disp('Input the xref index position you want to performe the calculations')
disp('Usually you want to pick the middle point of your field')
xref = input('?: ');

disp('Input the yref indices that you would like to perform the 2 point Correlation');
disp('Input as a vector format. Eg: [yref1 yref2 yref3]')
yref_vec = input('?: ');

disp('Choose the appropriate case')
disp('1. 2D or Stereo PIV')
disp('2. 90degree roatated 2D PIV')
disp('3. Cross-Plane Stereo with the original cameras coordinate sys')
type = input('?: ');

disp('Which direction would you like to perform line average?')
disp('1. Horizontal(Across rows)')
disp('2. Vertical(Across columns)')
direction = input('?: ');

savename = input('Type the name of the output file: ','s');
savename = [savename '.dat'];

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
%%%%%%%%%%%%%%%%%%%%%%
% Start computing Time
tstart_p = tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split the list of the files into the number of cores
[CompVecList] = DistVecContent(cores,files);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of input Variables
N = length(cols);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of output Variables
NoVar = (N * ( N + 1 ) / 2 );

%% %%%%%%%%%%%%%%%
% Number of Files
NoF = length(files);

for j=1:length(yref_vec)
    disp(['Calculating the 2P Correlation for yref ' num2str(j)])
    yref = yref_vec(j);
    
    spmd
        for i=1:length(CompVecList)
            
            vecfile = CompVecList(i).name;
            pathvecfile = strcat(pathDir,slash,vecfile);
            [nc,I,J,Dx,Dy,A] = matrixCell(pathvecfile);
            
            %%%%%%%%%%%%%%%%%%%%%% 
            % Some Initializations
            if i == 1
                X = A{1};
                Y = A{2};
                U = cell(1,N);
                
                Sigma_Y_U_p = cell(1,N);
                for k=1:N
                    Sigma_Y_U_p{k} = zeros(J,I);
                end
                
                RhoUcell_p = cell(1 ,  N * ( N + 1 ) / 2 );
                for k=1:NoVar
                    RhoUcell_p{k} = zeros(J,I);
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Put the variables inside Cell U
            for m = 1:N
                U{m} = A{cols(m)};
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % BE CAREFUL: LCI IS MULTIPLIED BY -1%
            if type == 3 && length(U) == 4       %
               U{4} = U{4} * -1;                 %   
            end                                  %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Compute the Correlations and Sigmas
            [RhoUcell , Sigma_Y_U] = TwoPointCorrFunc(U,xref,yref,type);
            
            for k=1:NoVar
                RhoUcell_p{k} = RhoUcell{k} + RhoUcell_p{k};
            end
            
            for k=1:N
                Sigma_Y_U_p{k} = Sigma_Y_U{k} + Sigma_Y_U_p{k};
            end
        end
    end
    
    X = X{1};
    Y = Y{1};
    I = I{1};
    J = J{1};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initializing the final matricies
    Sigma_Y_U = cell(1,N);
    for k=1:N
        Sigma_Y_U{k} = zeros(J,I);
    end
    RhoUcell = cell(1 ,  N * ( N + 1 ) / 2 );
    for k=1:NoVar
        RhoUcell{k} = zeros(J,I);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Gather the correlation from each core
    for c=1:cores
        dummy = RhoUcell_p{c};
        for k=1:NoVar
            RhoUcell{k} = dummy{k} + RhoUcell{k};
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Gather Sigma from each core
    for c=1:cores
        dummy = Sigma_Y_U_p{c};
        for k=1:N
            Sigma_Y_U{k} = dummy{k} + Sigma_Y_U{k};
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ensemble Average the Correlation
    for k=1:NoVar
        RhoUcell{k} = RhoUcell{k} / NoF;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Take the RMS of the Velocities
    for k = 1:N
        Sigma_Y_U{k} = sqrt(Sigma_Y_U{k}/NoF);
        %         Sigma_Y_U{k} = sqrt(nanmean(Sigma_Y_U{k},direction));
        if type == 2
            Sigma_Yref{k} = Sigma_Y_U{k}(xref,yref);
            
        else
            Sigma_Yref{k} = Sigma_Y_U{k}(yref,xref);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Normalizing the Correlation
    p=1;
    q=1;
    if type ~= 2
        for k=1:NoVar
            
            RhoUcell_n{k} = RhoUcell{k} ./(Sigma_Yref{p}.*Sigma_Y_U{q});
            
            %             for n=1:size(RhoUcell{k},1)
            %                 sigma_uiuj = (Sigma_Yref{p} * Sigma_Y_U{q}(n));
            %
            %                 for m=1:size(RhoUcell{k},2)
            %                     RhoUcell_n{k}(n,m) = RhoUcell{k}(n,m)./ sigma_uiuj;
            %                 end
            %             end
            
            if q ~=N
                q = q + 1;
            elseif q == N
                p = p + 1;
                q = p;
            end
            
        end
        
    elseif type == 2
        for k=1:NoVar
            
            RhoUcell_n{k} = RhoUcell{k} ./(Sigma_Yref{p}.*Sigma_Y_U{q});
            
            %             for n=1:size(RhoUcell{k},2)
            %                 sigma_uiuj = (Sigma_Yref{p} * Sigma_Y_U{q}(n));
            %
            %                 for m=1:size(RhoUcell{k},1)
            %                     RhoUcell_n{k}(m,n) = RhoUcell{k}(m,n) / sigma_uiuj;
            %                 end
            %
            %             end
            
            if q ~=N
                q = q + 1;
            elseif q == N
                p = p + 1;
                q = p;
            end
            
        end
    end
    
    disp('')
    disp('Saving the results')
    
    if type ~= 2
        zone = num2str(Y(yref,xref));
        Rx = X - X(yref,xref);
        Ry = Y;
        
    elseif type == 2
        zone = num2str(Y(xref,yref));
        Rx = Y - Y(xref,yref);
        Ry = X;
    end
    
    data = mixingCell(I,J,X,Y,RhoUcell);
    data = sortrows(data , [2 , 1]);
    data = dealNaN(data);
    
    data_n = mixingCell(I,J,Rx,Ry,RhoUcell_n);
    data_n = sortrows(data_n , [2 , 1]);
    data_n = dealNaN(data_n);
    
    if type == 2
        header = ['ZONE T = "y_ref=' zone 'mm" I =' , num2str(J) , ' J = ', num2str(I) , ' F = POINT'];
    else
        header = ['ZONE T = "y_ref=' zone 'mm" I =' , num2str(I) , ' J = ', num2str(J) , ' F = POINT'];
    end
    
    if j == 1
        saver(ResultsFol,['UnNorm_' savename],header,data)
        saver(ResultsFol,['Norm_' savename],header,data_n)
    else
        saverappend(ResultsFol,['UnNorm_' savename],header,data)
        saverappend(ResultsFol,['Norm_' savename],header,data_n)
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

% figure
% for i=1:NoVar
%     subplot(ceil(NoVar/2),2,i),[c,h]=contourf(Rx,Ry,RhoUcell_n{i},31);
%     set(h,'LevelList',[-0.3:0.025:1])
%     axis equal
% end