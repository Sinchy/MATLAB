function [k, n] = ScalingModel(Re)
n_max = Re^(3/4);
a = 2; 
C2 = 2.1;
b = 4;

% adjust Re
 Re = (b / C2) ^ (1/2) * Re;

C3 = 1;
n_tr = (15 * C2)^(3/4);
n1 = n_tr/20 : n_tr/20 : n_tr;
n2 = n_tr: n_max/100 : n_max;

k1 = log(15 * C2 * C3 * Re^(1/2).* n1.^(-2)/(a * b))./log((15 * C2 / b)^(-1/2) *  C3 * Re^(1/2));
% k2 = 1 - log(a * b ^ (3/2))./(1/2 * log(b) + 1/2 * log( C3 * Re) - 2/3 * log(n2));
k2 = 1 - log(a * b ^ (3/2))./log(b^(1/2) * Re^(1/2) * n2.^(-2/3));

n = [n1, n2];
k = [k1, k2];

% figure;
% plot(n, k+2);

end

