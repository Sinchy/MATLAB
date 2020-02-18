function [RhoUcell , Sigma_Y_U] = TwoPointCorrFunc(U,xref,yref,type)

% Perform the Two-point correlation of all the input variables
%
% Core function by Ricardo Mejia-Alvarez
% Author: Julio Barros
% UIUC - 2011

N = length(U);

RhoUcell = cell(1 ,  N * ( N + 1 ) / 2 );
Sigma_Y_U = cell(1 , N );

c = 1;

for k = 1 : N
    
    u = U{k};
    
    % Calculate RMS spectra at y for normalization purposes.
    Sigma_Y_U{k} = u.^2;
    
    for m = k : N
        
        if m ~= k
            v = U{m};
        else
            v = u; 
        end
        
        if type == 2
            RhoUcell{c} = u(xref,yref) * v;
        else
            RhoUcell{c} = u(yref,xref) * v;
        end
        c = c + 1;

    end
end