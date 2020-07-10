function [P, l] = DispersionMultiFractalPDFModel(L0, v0, t)

l = L0/1e4 : L0/1e4 : 2*L0;
for i = 1 : length(l)
   P(i) = integral(@(h)  l(i) .^ (4 - D(h) - h) .* L0 .^ (D(h) + h - 3) * t ...
       .* exp(- l(i) .^ (2 - 2*h) .* L0 .^ (2*h) * t ^ (-2) / (2 * v0^2)) / v0, 1/9, 0.38);
end
[l, P] = NormalizationPDF(l, P);
end

function D = D(h)
p = (3/log(2/3)) * log((1 - 9*h)./(6 * log(2/3)));
D = 1 + p .* (h - 1/9) + 2 * (2/3) .^ (p/3);

% c1 = 3 * ((1 + log(log(3/2)))/log(3/2) - 1);
% c2 = 3 / log(3/2);
% D = 1 + c1 * (h - 1/9) - c2 * (h - 1/9) .* log(h - 1/9);
end

