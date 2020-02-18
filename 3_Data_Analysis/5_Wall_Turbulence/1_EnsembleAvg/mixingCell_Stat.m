function [Umix] = mixingCell_Stat(I,J,AxisCell,Ucell,uiujCell,varargin)
% this function reshapes matrices into column vectors and concatenate them
% into a single matrix. Each matrix will be a column of the resultant matrix
% I: number of columns in Matlab matrix format
% J: number of rows in Matlab matrix format
% Uk: is the k-th matrix. All these matrices should be of the same size
%
% Modified by Julio Barros
% created by Ricardo Mejia-Alvarez. Urbana, IL. 09/25/09

L = length( AxisCell );
for k = 1 : L
    if k ~= 1
        Xk = AxisCell{k};
        Xk = reshape(Xk,I * J,1);
        X = [X,Xk]; %#ok<AGROW>
        
    else
        X = AxisCell{k};
        X = reshape(X,I * J,1);
    end
end

L = length( Ucell );
for k = 1 : L
    if k ~= 1
        Uk = Ucell{k};
        Uk = reshape(Uk,I * J,1);
        U = [U,Uk]; %#ok<AGROW>
        
    else
        U = Ucell{k};
        U = reshape(U,I * J,1);
    end
end

L = length( uiujCell );
for k = 1 : L
    if k ~= 1
        uk = uiujCell{k};
        uk = reshape(uk,I * J,1);
        u = [u,uk]; %#ok<AGROW>
        
    else
        u = uiujCell{k};
        u = reshape(u,I * J,1);
    end
end

for k=1:length(varargin)
    if k ~= 1
        Vk = varargin{k};
        Vk = reshape(Vk,I * J,1);
        Var = [Var,Vk]; %#ok<AGROW>
    else
        Var = varargin{k};
        Var = reshape(Var,I * J,1);
    end
end
Umix = [X U u Var];