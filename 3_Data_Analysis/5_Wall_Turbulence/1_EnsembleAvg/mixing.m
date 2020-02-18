%this function reshapes matrices into column vectors and concatenate them
%into a single matrix. Each matrix will be a column of the resultant matrix
%I: number of columns in Matlab matrix format
%J: number of rows in Matlab matrix format
%Uk: is the k-th matrix. All these matrices should be of the same size

%created by Ricardo Mejia-Alvarez. Urbana, IL. 09/25/09

function [U] = mixing(I,J,varargin)


for k = 1 : length(varargin)
    
    if k ~= 1
        Uk = cell2mat( varargin(k) );
        Uk = reshape(Uk,I * J,1);
        U = [U,Uk]; %#ok<AGROW>
        
    else
        U = cell2mat( varargin(k) );
        U = reshape(U,I * J,1);
    end

end


end