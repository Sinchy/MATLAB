function fluctuation_SwirlingFields
% Compute and save the Fluctuation Fields as well as the Swirling Strength
% fields
% It also takes advantage of the Parallel Computing
%
% Author: Julio Barros
% UIUC
% 06/08/2010

clear
close
clc

if ispc == 1
    slash = '\';
else
    slash = '/';
end

% Close if there is any open pool
if matlabpool('size') > 0;
    matlabpool close force local
end
% Start the Parallel pools
matlabpool open
cores = matlabpool('size'); % Number of cores availabe in the computer

application = input('2D, Stereo, 3D ? ','s');

disp('Was the Ensemble average croped?')
ask = input('y , n ? ','s');
if strcmp(ask,'y')==1 || strcmp(ask,'Y')==1
    disp('Input the crop vector [left right top bottom]')
    crop = input('Crop vector ');
else
    crop = [1 1 1 1];
end


if strcmp(application,'Stereo')==1
    
    ext = '*.V3D';
    
    pathDir = uigetdir('','Select the directory in which has the vector fields');
    files = dir(strcat(pathDir,slash,ext));
    FlucFolder = strcat(pathDir,slash,'Fluctuation',slash);
    
    % Split the list of the files into the number of cores
    [CompVecList] = CompDirContent(cores,files);
    
    % Open the file that has the Ensemble Average Filed
    [EnsembleFile,EnsemblePath] = uigetfile('*.dat');
    [~,Im,Jm,~,~,Xm,Ym,Zm,U,V,W,~,~,~,~,~,~] = matrix([EnsemblePath slash EnsembleFile]);
    
    disp('Which direction is the main flow?')
    Mainflow = input('U , V , W ? ','s');
    
    if strcmp(Mainflow,'U') == 1
        % Compute the Mean Profile
        Umean = nanmean(U,2);
        Vmean = nanmean(V,2);
        Wmean = nanmean(W,2);
    elseif strcmp(Mainflow,'W') == 1
        % Compute the Mean Profile
        Umean = nanmean(W,2);
        Vmean = nanmean(V,2);
        Wmean = nanmean(U,2);
    end
    
    spmd
        
        for i=1:length(CompVecList)
            
            % Open the velocity fields files
            vecfile = CompVecList(i).name;
            pathvecfile = strcat(pathDir,slash,vecfile);
            [~,~,~,Dx,Dy,~,~,~,U,V,W,CHC] = matrix(pathvecfile);
            
            % Crop the matrices based on the ROI
            %X = X(crop(4):end-crop(3),crop(1):end-crop(2));
            %Y = Y(crop(4):end-crop(3),crop(1):end-crop(2));
            %Z = Z(crop(4):end-crop(3),crop(1):end-crop(2));
            U = U(crop(4):end-crop(3),crop(1):end-crop(2));
            V = V(crop(4):end-crop(3),crop(1):end-crop(2));
            W = W(crop(4):end-crop(3),crop(1):end-crop(2));
            CHC = CHC(crop(4):end-crop(3),crop(1):end-crop(2));
            
            % Make the CHC 0's and 1's
            CHC = CHC./abs(CHC);
            CHC = (CHC+abs(CHC))/2;
            %test = CHC; %DEBUG PURPOSE
            
            % Multiply the remaining outliers by CHC normalized
            U = U.*CHC;
            V = V.*CHC;
            W = W.*CHC;
            
            if strcmp(Mainflow,'U')==1
                u = zeros(size(U));
                v = zeros(size(V));
                w = zeros(size(W));
                for col=1:Im
                    u(:,col) = U(:,col) - Umean;
                    v(:,col) = V(:,col) - Vmean;
                    w(:,col) = W(:,col) - Wmean;
                end
                
            elseif strcmp(Mainflow,'W')==1
                u = zeros(size(U));
                v = zeros(size(U));
                w = zeros(size(U));
                for col=1:Im
                    u(:,col) = W(:,col) - Umean;
                    v(:,col) = V(:,col) - Vmean;
                    w(:,col) = U(:,col) - Wmean;
                end
                
                %Grid spacing in meters
                dz = Dx/1000; % Should be scaled properly (m)
                dy = Dy/1000; % Should be scaled properly (m)
                
                % Calculate the Swirling Strength
                [Lambda] = swirlingStrength(dz,dy,w,v);
                
            end
            
            % Save the fluctuation field
            fluc = mixing(Im,Jm,Xm,Ym,Zm,u,v,w,Lambda);
            TecplotHeader = ['VARIABLES="X", "Y", "Z", "u", "v", "w", "Swirling Strength" '...
                'ZONE I=' num2str(Jm) ', J=' num2str(Im) ', K=1, F=POINT'];
            flucfile = [vecfile(1:end-4) '_fluc.dat'];
            saver([FlucFolder slash],flucfile,TecplotHeader,fluc);
        end
        
    end
    
end

matlabpool close