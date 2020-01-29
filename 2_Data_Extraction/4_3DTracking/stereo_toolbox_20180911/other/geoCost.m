function out = geoCost(f1, f2, a, b, c, d, t)

    out = t.^2./(1 + f1^2.*t.^2) + ...
            (c.*t+d).^2 ./ ((a.*t+b).^2 + f2^2.*(c.*t+d).^2);