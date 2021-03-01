function x2D = UnDistort(X2D,camParaCalib) 
    
    kr = camParaCalib.k1;
    X = (X2D(:,1) - 512)*0.02;
    Y = (-X2D(:,2) + 512)*0.02;

    if (kr ~= 0)
        a = X ./ Y;

        Y = (1 - sqrt(1 - 4 .* Y.^2 .* kr.*(a.^2 + 1))) / (2.* Y.* kr.* (a.^2 + 1));
        X = a.*Y;
    end
    
    x2D = [X Y];
end