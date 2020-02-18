function [uiujCell,lci,omega] = ReynoldsStress(CompVecList,cores,Ucell,Lciavg,Omega_avg,crop,pathDir,flucask)

if ispc == 1
    slash ='\';
else
    slash ='/';
end

FlucFol = strcat(pathDir,slash,'Fluctuation');
mkdir(FlucFol)

% Number of input variables
N = length(Ucell);

% Number of output Variables
NoVar = (N * ( N + 1 ) / 2 );

% number of columns in the Average velocity
[J,I] = size(Ucell{1});

if N == 2
    Uavg = Ucell{1};
    Vavg = Ucell{2};
elseif N == 3
    Uavg = Ucell{1};
    Vavg = Ucell{2};
    Wavg = Ucell{3};
end

spmd
    % Bunch of Initializations
    uu_p = zeros(J,I);
    uv_p = zeros(J,I);
    vv_p = zeros(J,I);
    if N == 3
        uw_p = zeros(J,I);
        vw_p = zeros(J,I);
        ww_p = zeros(J,I);
    end
    lci_p = zeros(J,I);
    omega_p = zeros(J,I);
    CHC_p = zeros(J,I);
    
    for i=1:length(CompVecList)
        
        vecfile = CompVecList(i).name;
        pathvecfile = strcat(pathDir,slash,vecfile);
        
        if i == 1
            [nc,Iori,Jori] = matrix(pathvecfile);
            if nc == 5 || nc == 9 || nc == 11
                [~,~,~,Dx,Dy,X,Y,U,V,CHC] = matrix(pathvecfile);
                [~,~,X,Y] = WindowFile(crop,Iori,Jori,X,Y);
            elseif nc == 8 || nc == 7
                [~,~,~,Dx,Dy,X,Y,Z,U,V,W,CHC] = matrix(pathvecfile);
                [~,~,X,Y,Z] = WindowFile(crop,Iori,Jori,X,Y,Z);
            end
            
            %              X = X(crop(4):end-crop(3),crop(1):end-crop(2));
            %              Y = Y(crop(4):end-crop(3),crop(1):end-crop(2));
            %              Z = Z(crop(4):end-crop(3),crop(1):end-crop(2));
            
        else
            if nc == 5 || nc == 9 || nc == 11
                [~,~,~,~,~,~,~,U,V,CHC] = matrix(pathvecfile);
            elseif nc == 8 || nc == 7
                [~,~,~,~,~,~,~,~,U,V,W,CHC] = matrix(pathvecfile);
            end
        end
        
        % Crop the matrices based on the ROI
        [~,~,U,V,CHC] = WindowFile(crop,Iori,Jori,U,V,CHC);
        %         U = U(crop(4):end-crop(3),crop(1):end-crop(2));
        %         V = V(crop(4):end-crop(3),crop(1):end-crop(2));
        %         CHC = CHC(crop(4):end-crop(3),crop(1):end-crop(2));
        if nc == 8 || nc == 7
            %            W = W(crop(4):end-crop(3),crop(1):end-crop(2));
            [~,~,W] = WindowFile(crop,Iori,Jori,W);
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
        dx = Dx/1000; % mm to m
        dy = Dy/1000;
        [Lci,Omega] = swirlingStrength(dx,dy,U,V);
        
        % Compute the Fluctation Fields
        u = U - Uavg;
        v = V - Vavg;
        if nc == 8 || nc == 7
            w = W - Wavg;
        end
        
        if strcmp(flucask,'y') == 1
            %savename = strcat(FlucFol,vecfile);
            savename = vecfile(1:end-4);
            savename = strcat('Fluc_',savename,'.dat');
            if nc == 5 || nc == 9 || nc == 11
                data = mixing(I,J,X,Y,u,v,Lci,Omega,CHC);
            elseif nc == 8 || nc == 7
                data = mixing(I,J,X,Y,Z,u,v,w,Lci,Omega,CHC);
            end
            data = dealNaN(data);
            data = sortrows(data,[2,1]);
            
            if nc == 5 || nc == 9 || nc == 11
                TecplotHeader = ['VARIABLES="x", "y", "u", "v", "lci", "Omega", "CHC", '...
                    'ZONE I=' num2str(I) ', J=' num2str(J) ', K=1, F=POINT'];
            elseif nc == 8 || nc == 7
                TecplotHeader = ['VARIABLES="x", "y", "z", "u", "v", "w", "lci", "Omega", "CHC", '...
                    'ZONE I=' num2str(I) ', J=' num2str(J) ', K=1, F=POINT'];
            end
            saver([FlucFol slash],savename,TecplotHeader,data)
        end
        
        
        uu_p = uu_p + (U - Uavg).^2;
        uv_p = uv_p + (U - Uavg).*(V - Vavg);
        vv_p = vv_p + (V - Vavg).^2;
        if nc == 8 || nc == 7
            ww_p = ww_p + (W - Wavg).^2;
            uw_p = uw_p + (U - Uavg).*(W - Wavg);
            vw_p = vw_p + (V - Vavg).*(W - Wavg);
        end
        
        lci_p = lci_p + (Lci - Lciavg).^2;
        omega_p = omega_p + (Omega - Omega_avg).^2;
        CHC_p = CHC_p + CHC;
    end
end

nc = nc{1};
% Initializing the final matricies
uu = zeros(size(uu_p{1}));
uv = uu;
vv = uu;
if nc == 8 || nc == 7
    ww = uu;
    uw = uu;
    vw = uu;
end
lci = uu;
omega = uu;
CHCavg = uu;

for i=1:cores
    uu = uu_p{i} + uu;
    uv = uv_p{i} + uv;
    vv = vv_p{i} + vv;
    if nc == 8 || nc == 7
        ww = ww_p{i} + ww;
        uw = uw_p{i} + uw;
        vw = vw_p{i} + vw;
    end
    lci = lci_p{i} + lci;
    omega = omega_p{i} + omega;
    CHCavg = CHC_p{i} + CHCavg;
end

% Calculating the final ensemble average
uu = uu./CHCavg;
vv = vv./CHCavg;
uv = uv./CHCavg;
if nc == 8 || nc == 7
    ww = ww./CHCavg;
    uw = uw./CHCavg;
    vw = vw./CHCavg;
end
lci = sqrt(lci./CHCavg);
omega = sqrt(omega./CHCavg);

uiujCell = cell(1,NoVar);
if N == 2
    uiujCell{1} = uu;
    uiujCell{2} = uv;
    uiujCell{3} = vv;
elseif N == 3
    uiujCell{1} = uu;
    uiujCell{2} = uv;
    uiujCell{3} = uw;
    uiujCell{4} = vv;
    uiujCell{5} = vw;
    uiujCell{6} = ww;
end
