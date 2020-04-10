function [tn, Rn] = NormalizePairDispersion(struct_disprate, R, IS)
%disp_rate: m^2/s^3
IS(IS == 0) = [];
r0 = mean(IS);

if isscalar(struct_disprate)
    disp_rate = struct_disprate;
     S = 11/3 * 2.1 * (disp_rate * 1e6 * mean(IS))^(2/3);
else 
    struct = struct_disprate;
%     S = interp1(struct(:,1), struct(:,2), r0) + 2 * interp1(struct(:,1), struct(:,3), r0);
    S = interp1(struct(:,1), struct(:,2), r0) * 11/3 / (4/3);
%     disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
    disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
end
    t0 = CalT0(disp_rate, r0);
    Rn = R / (t0^2 * S);
% Rn = R / (S);
    tn = (1:length(R))/4000/t0;
% tn = (1:length(R))/4000;
end

