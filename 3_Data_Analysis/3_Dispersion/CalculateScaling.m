function fp = CalculateScaling(tn, Rn)
fit_len = 60;

len = length(Rn);
fp = zeros(len-fit_len, 1);
for i = 1 : len - fit_len
    x = log(tn(i : i + fit_len))';
    y = log(Rn(i : i + fit_len));
    f = fit(x, y, 'poly1');
    fp(i) = f.p1;
end



end

