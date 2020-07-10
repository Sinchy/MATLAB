function fp = CalculateScaling(tn, Rn, all)
if ~all
    fit_len = 100;

    len = length(Rn);
    if len < fit_len
        fit_len = len - 1;
    end
    fp = zeros(len-fit_len, 3);
    % fit_len = len - 1;
    for i = 1 : len - fit_len 
        x = log(tn(i : i + fit_len));
        y = log(Rn(i : i + fit_len));
        f = fit(x, y, 'poly1');

        fconf = confint(f);
        fp(i, :) = [f.p1, fconf(:,1)'];
    end
else
    x = log(tn);
    y = log(Rn);
    f = fit(x, y, 'poly1');
    fconf = confint(f);
    fp = [f.p1, fconf(:,1)'];
end



end

