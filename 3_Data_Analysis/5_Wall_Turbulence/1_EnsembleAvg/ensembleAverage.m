function [AxisCell,Ucell,Lciavg,Omega_avg,CHCavg] = ensembleAverage(CompVecList,cores,crop,pathDir)
% Read all the velocity data of a Stereo experiment inside the current folder
% and calculate the emsemble averages of the velocities.
%
% Output variables:
%
% AxisCell is a cell vector that contains the Axis variables. If it's a 2D
% PIV AxisCell has X and Y. If it's a Stereo, AxisCell has X,Y and Z
%
% Ucell is a cell vector that contains the Velocities variables
%
%
% Author: Julio Barros
% University of Illinois at Urbana-Champaign
% Date: 05/10/2011
% Version: 2.1
%
% Major modification that uses a single function for all the PIV cases
% Handles Insight 9

if ispc == 1
    slash = '\';
else
    slash ='/';
end

spmd
    % Initilization of te Variables
    % Find how many columns the file has
    vecfile = CompVecList(1).name;
    vecfile = strcat(pathDir,slash,vecfile);
    [nc,Iori,Jori] = matrix(vecfile);
    
    if nc == 5 || nc == 9 || nc == 11
        [~,~,~,Dx,Dy,X,Y,U,V,CHC] = matrix(vecfile);
    elseif nc == 8 || nc == 7
        [~,~,~,Dx,Dy,X,Y,Z,U,V,W,CHC] = matrix(vecfile);
    end
    
    % Crop the matrices based on the ROI
    [~,~,X,Y,U,V,CHC] = WindowFile(crop,Iori,Jori,X,Y,U,V,CHC);
    %     X = X(crop(4):end-crop(3),crop(1):end-crop(2));
    %     Y = Y(crop(4):end-crop(3),crop(1):end-crop(2));
    %     U = U(crop(4):end-crop(3),crop(1):end-crop(2));
    %     V = V(crop(4):end-crop(3),crop(1):end-crop(2));
    %     CHC = CHC(crop(4):end-crop(3),crop(1):end-crop(2));
    if nc == 8 || nc == 7
        [~,~,Z,W] = WindowFile(crop,Iori,Jori,Z,W);
        %         Z = Z(crop(4):end-crop(3),crop(1):end-crop(2));
        %         W = W(crop(4):end-crop(3),crop(1):end-crop(2));
    end
    
    % Make the CHC 0's and 1's
    %CHC = CHC./abs(CHC);
    %CHC = (CHC+abs(CHC))/2;
    CHC = double(CHC > 0);
    %test = CHC; %DEBUG PURPOSE
    
    % Multiply the remaining outliers by CHC normalized
    U = U.*CHC;
    V = V.*CHC;
    if nc == 8  || nc == 7
        W = W.*CHC;
    end
    
    % Calculate the Swirling Strength
    dx = Dx/1000;
    dy = Dy/1000;
    [Lci,Omega] = swirlingStrength(dx,dy,U,V);
    
    % Start the Ensemble average matrices
    Uavg_p = U;
    Vavg_p = V;
    if nc == 8  || nc == 7
        Wavg_p = W;
    end
    Lciavg_p = Lci;
    Omega_p = Omega;
    CHC_p = CHC;
    
    for i=2:length(CompVecList)
        vecfile = CompVecList(i).name;
        vecfile = strcat(pathDir,slash,vecfile);
        if nc == 5 || nc == 9 || nc == 11
            [~,~,~,Dx,Dy,~,~,U,V,CHC] = matrix(vecfile);
        elseif nc == 8 || nc == 7
            [~,~,~,Dx,Dy,~,~,~,U,V,W,CHC] = matrix(vecfile);
        end
        
        % Crop the matrices based on the ROI
        [~,~,U,V,CHC] = WindowFile(crop,Iori,Jori,U,V,CHC);
        %         U = U(crop(4):end-crop(3),crop(1):end-crop(2));
        %         V = V(crop(4):end-crop(3),crop(1):end-crop(2));
        %         CHC = CHC(crop(4):end-crop(3),crop(1):end-crop(2));
        if nc == 8 || nc == 7
            [~,~,W] = WindowFile(crop,Iori,Jori,W);
            %            W = W(crop(4):end-crop(3),crop(1):end-crop(2));
        end
        
        % Make the CHC 0's and 1's
        %CHC = CHC./abs(CHC);
        %CHC = (CHC+abs(CHC))/2;
        CHC = double(CHC > 0);
        
        % Multiply the remaining outliers by CHC normalized
        U = U.*CHC;
        V = V.*CHC;
        if nc == 8 || nc == 7
            W = W.*CHC;
        end
        
        % Calculate the Swirling Strength
        dx = Dx/1000;
        dy = Dy/1000;
        [Lci,Omega] = swirlingStrength(dx,dy,U,V);
        
        Uavg_p = Uavg_p + U;
        Vavg_p = Vavg_p + V;
        if nc == 8 || nc == 7
            Wavg_p = Wavg_p + W;
        end
        Lciavg_p = Lciavg_p + Lci;
        Omega_p = Omega_p + Omega;
        CHC_p = CHC_p + CHC;
        
    end
end

% Gathers some variables from the first core just for exporting purposes
nc = nc{1};
X = X{1};
Y = Y{1};
if nc == 8 || nc == 7
    Z = Z{1};
end
%I = I{1};
%J = J{1};

% Initializing the final average matrices
%Xavg = zeros(size(Xavg_p{1})); %DEGUB PURPOSE
Uavg = zeros(size(Uavg_p{1}));
Vavg = Uavg;
if nc == 8 || nc == 7
    Wavg = Uavg;
end
Lciavg = Uavg;
Omega_avg = Uavg;
CHCavg = Uavg;
%debug1 = Uavg;
%debug2 = Uavg;

% Adding all the cores matrices
for i=1:cores
    Uavg = Uavg_p{i} + Uavg;
    Vavg = Vavg_p{i} + Vavg;
    if nc == 8 || nc == 7
        Wavg = Wavg_p{i} + Wavg;
    end
    Lciavg = Lciavg_p{i} + Lciavg;
    Omega_avg = Omega_p{i} + Omega_avg;
    CHCavg = CHC_p{i} + CHCavg;
    %debug1 = debug_p1{i} + debug1;
    %debug2 = debug_p2{i} + debug2;
end

% Calculatibg the final Ensemble Averages
Uavg = Uavg./CHCavg;
Vavg = Vavg./CHCavg;
if nc == 8 || nc == 7
    Wavg = Wavg./CHCavg;
end
Lciavg = Lciavg./CHCavg;
Omega_avg = Omega_avg./CHCavg;

% Outputing the variables in cell format
if nc == 5 || nc == 9 || nc == 11
    AxisCell = cell(1,2);
    Ucell = cell(1,2);
    % Not an elegant way
    AxisCell{1} = X;
    AxisCell{2} = Y;
    % Not an elegant way
    Ucell{1} = Uavg;
    Ucell{2} = Vavg;
elseif nc == 8 || nc == 7
    AxisCell = cell(1,3);
    Ucell = cell(1,3);
    % Not an elegant way
    AxisCell{1} = X;
    AxisCell{2} = Y;
    AxisCell{3} = Z;
    % Not an elegant way
    Ucell{1} = Uavg;
    Ucell{2} = Vavg;
    Ucell{3} = Wavg;
end