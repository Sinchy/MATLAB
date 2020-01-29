function[X,Y] = UnDistort(X,Y,kr) 

%     X = (x - 512)*0.02;
%     Y = (-y + 512)*0.02;

    if (kr ~= 0)
        a = X / Y;

        Y = (1 - sqrt(1 - 4 * Y^2 * kr*(a^2 + 1))) / (2 * Y * kr * (a^2 + 1));
        X = a*Y;
    end
end