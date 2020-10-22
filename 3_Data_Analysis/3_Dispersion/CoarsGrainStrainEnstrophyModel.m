function [meanstrain, enstrophy] = CoarsGrainStrainEnstrophyModel(disp_rate, L, len_kol, filter_length)
fun = @(x) StructFunModel(disp_rate, L, len_kol, x) * 1800 / filter_length ^2 .* ( x / filter_length) .^3 ...
    .* ( 1 - 2 * (x / filter_length) .^ 2) .* ( (x / filter_length) .^ 2 - 1) / filter_length;
enstrophy = integral(fun, 0, filter_length);
meanstrain = 1 / 2 * enstrophy;
end

