function fp = CalculateScaling(tn, Rn)
fit_len = 100;

len = length(Rn);
fp = zeros(len-fit_len, 3);
for i = 1 : len - fit_len
    x = log(tn(i : i + fit_len))';
    y = log(Rn(i : i + fit_len));
    f = fit(x, y, 'poly1');
    
    fconf = confint(f);
    fp(i, :) = [f.p1, fconf(:,1)'];
end



end

