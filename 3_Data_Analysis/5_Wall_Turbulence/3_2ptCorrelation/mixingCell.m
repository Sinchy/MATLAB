function [U] = mixingCell(I,J,X,Y,Umat)
% this function reshapes matrices into column vectors and concatenate them
% into a single matrix. Each matrix will be a column of the resultant matrix
% I: number of columns in Matlab matrix format
% J: number of rows in Matlab matrix format
% Uk: is the k-th matrix. All these matrices should be of the same size
%
% Modified by Julio Barros
% created by Ricardo Mejia-Alvarez. Urbana, IL. 09/25/09

L = length( Umat );
X = reshape(X,I*J,1);
Y = reshape(Y,I*J,1);
for k = 1 : L
    
    if k ~= 1
        Uk = Umat{k};
        Uk = reshape(Uk,I * J,1);
        U = [U,Uk]; %#ok<AGROW>
        
    else
        U = Umat{k};
        U = reshape(U,I * J,1);
    end
end

U = [X Y U];