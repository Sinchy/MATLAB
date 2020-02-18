%function generateSwirlVort
% Compute and save the Swirling Strength as well as the
% Voriticity fields
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

pathDir = uigetdir('','Select the directory in which has the vector fields');
FlucFolder = strcat(pathDir,slash,'SwirlVort',slash);

if strcmp(application,'Stereo') == 1
    
    ext = '*.V3D';
    files = dir(strcat(pathDir,slash,ext));
    
    % Split the list of the files into the number of cores
    [CompVecList] = DistVecContent(cores,files);
    
    spmd
        
        for i=1:length(CompVecList)
            
            % Open the velocity fields files
            vecfile = CompVecList(i).name;
            pathvecfile = strcat(pathDir,slash,vecfile);
            [~,I,J,Dx,Dy,X,Y,Z,U,V,W,CHC] = matrix(pathvecfile);
            
            %             % Crop the matrices based on the ROI
            %             %X = X(crop(4):end-crop(3),crop(1):end-crop(2));
            %             %Y = Y(crop(4):end-crop(3),crop(1):end-crop(2));
            %             %Z = Z(crop(4):end-crop(3),crop(1):end-crop(2));
            %             U = U(crop(4):end-crop(3),crop(1):end-crop(2));
            %             V = V(crop(4):end-crop(3),crop(1):end-crop(2));
            %             W = W(crop(4):end-crop(3),crop(1):end-crop(2));
            %             CHC = CHC(crop(4):end-crop(3),crop(1):end-crop(2));
            
            %             % Make the CHC 0's and 1's
            %             CHC = CHC./abs(CHC);
            %             CHC = (CHC+abs(CHC))/2;
            CHC = double(CHC>0);
            %test = CHC; %DEBUG PURPOSE
            
            % Multiply the remaining outliers by CHC normalized
            U = U.*CHC;
            V = V.*CHC;
            W = W.*CHC;
            
            %Grid spacing in meters
            dz = Dx/1000; % Should be scaled properly (m)
            dy = Dy/1000; % Should be scaled properly (m)
            
            % Calculate the Swirling Strength
            [Lambda,Vort] = swirlingStrength(Dx,Dy,U,V);
            
            % Save the fluctuation field
            data = mixing(Im,Jm,Xm,Ym,Zm,U,V,W,Lambda,Vort,CHC);
            data = dealNaN(data);
            data = sortrows(data,[2,1]);
            
            TecplotHeader = ['VARIABLES="X", "Y", "Z", "U", "V", "W", "Lci", "Omega", "CHC" '...
                'ZONE I=' num2str(I) ', J=' num2str(J) ', K=1, F=POINT'];
            flucfile = [vecfile(1:end-4) '_SwirlVort.dat'];
            saver(FlucFolder,flucfile,TecplotHeader,data);
        end
    end
    
elseif strcmp(application,'2D') == 1
    
    ext = '*.vec';
    files = dir(strcat(pathDir,slash,ext));
    
    % Split the list of the files into the number of cores
    [CompVecList] = DistVecContent(cores,files);
    
    spmd
        
        for i=1:length(CompVecList)
            
            % Open the velocity fields files
            vecfile = CompVecList(i).name;
            pathvecfile = strcat(pathDir,slash,vecfile);
            [~,I,J,Dx,Dy,X,Y,U,V,CHC] = matrix(pathvecfile);
            
            %             % Crop the matrices based on the ROI
            %             %X = X(crop(4):end-crop(3),crop(1):end-crop(2));
            %             %Y = Y(crop(4):end-crop(3),crop(1):end-crop(2));
            %             %Z = Z(crop(4):end-crop(3),crop(1):end-crop(2));
            %             U = U(crop(4):end-crop(3),crop(1):end-crop(2));
            %             V = V(crop(4):end-crop(3),crop(1):end-crop(2));
            %             W = W(crop(4):end-crop(3),crop(1):end-crop(2));
            %             CHC = CHC(crop(4):end-crop(3),crop(1):end-crop(2));
            
            % Make the CHC 0's and 1's
            %             CHC = CHC./abs(CHC);
            %             CHC = (CHC+abs(CHC))/2;
            CHC = double(CHC>0);
            %test = CHC; %DEBUG PURPOSE
            
            % Multiply the remaining outliers by CHC normalized
            U = U.*CHC;
            V = V.*CHC;
            
            % Grid spacing in meters
            % dz = Dx/1000; % Should be scaled properly (m)
            % dy = Dy/1000; % Should be scaled properly (m)
            
            % Calculate the Swirling Strength
            [Lambda,Vort] = swirlingStrength(Dx,Dy,U,V);
            
            % Save the fluctuation field
            data = mixing(I,J,X,Y,U,V,Lambda,Vort,CHC);
            data = dealNaN(data);
            data = sortrows(data,[2,1]);
            
            TecplotHeader = ['VARIABLES="X", "Y", "U", "V", "Lci", "Omega", "CHC" '...
                'ZONE I=' num2str(I) ', J=' num2str(J) ', K=1, F=POINT'];
            flucfile = [vecfile(1:end-4) '_SwirlVort.dat'];
            saver(FlucFolder,flucfile,TecplotHeader,data);
        end
    end
    
end
matlabpool close