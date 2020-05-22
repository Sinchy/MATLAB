function exponent = EulerianStrFunModelIntermittency(L0, disp_rate)
num_order = 10;
% p = 1:1:num_order;
exponent = zeros(num_order, 3);
for p = 1:1:num_order
    num_point = 10;
    strFun = zeros(num_point,1);
    r = zeros(num_point, 1);
    fun = @(del_u, r) del_u .^ p .* PDFVelocityIncrement(L0, disp_rate, r, del_u);
    for n = 1 : num_point
        r(n) = L0 / 2^n;
        strFun(n) = integral(@(x) fun(x, r(n)), 0, Inf);
    end
    fp = CalculateScaling(r, strFun);
    exponent(p, :) = fp;
end
end

function p = PDFVelocityIncrement(L0, disp_rate, r, del_u)
% p-model in P. Kailasnath, K.R. Sreenivasan 1993

M = 0.3;
n = round(log(L0 / r) / log(2));
del_u_0 = (disp_rate * L0) ^ (1/3);
p = 0;
for k = 0 : n
    sigma = del_u_0 * M ^ (k/3) * (1 - M) ^ ((n - k)/3);
    p = p + nchoosek(n, k) * 2 ^ (-n) / (2 * pi * sigma ^ 2 ) ^ .5 * exp(- del_u .^ 2 / (2 * sigma ^ 2));
end
end