function [xx, yy] = BinMean(x, y, nbin)
xmin = min(x);
dx = (max(x) - xmin) / nbin;
for i = 1 : nbin
    x_l = xmin + (i - 1) * dx;
    x_u = xmin + i * dx;
    xx(i) = (x_l + x_u) / 2;
    yy(i) = mean(y(x > x_l & x < x_u));
    err(i) = std(y(x > x_l & x < x_u));
end
errorbar(xx, yy, err);
end

