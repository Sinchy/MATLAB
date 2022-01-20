function [tn, Rn] = CalBourgoinModel(struct_disprate, IS, integral_time)
%disp_rate: m^2/s^3
% IS: m

IS(IS == 0) = [];
r0 = mean(IS);

if isscalar(struct_disprate)
    disp_rate = struct_disprate;
%      S = 11/3 * 2.1 * (disp_rate * 1e6 * mean(IS))^(2/3);
else 
    struct = struct_disprate;
    S = interp1(struct(:,1), struct(:,2), r0) + 2 * interp1(struct(:,1), struct(:,3), r0);
    disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
end

dt = 1/4000;
t = dt:dt:integral_time;
% g = 0.55;
C = 7.7;
alpha = .01;
g = (2 * ( (1 + alpha^2 * C^3 / 4) ^ (1/3) - 1) / alpha / C) ^ 3;
D = (g * disp_rate *(t + ((mean(IS)).^2/(g*disp_rate)) .^(1/3)).^3).^.5;
R = (D-mean(IS)).^2;
[tn, Rn] = NormalizePairDispersion(struct_disprate, R, IS/1e3, 5000);
end

