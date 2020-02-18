function [RhoUcell , Sigma_Y_U] = HomogeTwoPointCorrFunc(U,yref,type)
% Perform the Homogeneous Two-point correlation of all the input variables
%
% Core function by Ricardo Mejia-Alvarez
% Author: Julio Barros
% UIUC - 2011

N = length(U);
[j,i] = size(U{1});

% Initializations
RhoUcell = cell(1 ,  N * ( N + 1 ) / 2 );
for p=1:length(RhoUcell)
    if type == 2
        RhoUcell{p} = zeros(2*j-1,i);
    else
        RhoUcell{p} = zeros(j,2*i-1);
    end
end

Sigma_Y_U = cell(1 , N );
for p=1:length(Sigma_Y_U)
    if type == 2
        Sigma_Y_U{p} = zeros(2*j-1,i);
    else
        Sigma_Y_U{p} = zeros(j,2*i-1);
    end
end

c = 1;

for k = 1 : N
    
    u = U{k};
    
    % Calculate RMS spectra at y for normalization purposes.
    if type == 2
        for i=1:size(Sigma_Y_U{k},2)
            Sigma_Y_U{k}(:,i) = xcorr(u(:,i));
        end
    else
        for i=1:size(Sigma_Y_U{k},1)
            Sigma_Y_U{k}(i,:) = xcorr(u(i,:));
        end
    end
    
    for m = k : N
        
        if m ~= k
            v = U{m};
        else
            v = u;
        end
        
        if type == 2
            for i=1:size(RhoUcell{c},2)
                %RhoUcell{c}(:,i) = xcorr(u(:,i),v(:,yref));
                RhoUcell{c}(:,i) = xcorr(u(:,yref),v(:,i));
            end
        else
            for i=1:size(RhoUcell{c},1)
                %RhoUcell{c}(i,:) = xcorr(u(i,:),v(yref,:));
                RhoUcell{c}(i,:) = xcorr(u(yref,:),v(i,:));
            end
        end
        
        c = c + 1;
    end
end