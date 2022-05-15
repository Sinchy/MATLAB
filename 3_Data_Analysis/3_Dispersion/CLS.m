function cls = CLS(t, R, e)
R = R.^(1/3);
dR = diff(R) ./ diff(t);
cls = dR .^ 3 / e;
end

