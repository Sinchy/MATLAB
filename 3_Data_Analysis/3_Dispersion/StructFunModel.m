function S = StructFunModel(disp_rate, L, len_kol, r)

S = 2 * ( 1 - exp(- r ./ (15 * 2.1) .^ (3/4) / len_kol) ) .^ (4/3) * ( disp_rate * L) ^ (2/3) ...
    .* ( r.^4 ./ ( 64 * L ^ 4 / 2.1 ^ 6 + r .^ 4)) .^ (1/6);

end

