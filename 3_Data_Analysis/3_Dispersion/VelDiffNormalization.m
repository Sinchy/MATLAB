function [tn,Vn] = VelDiffNormalization(vel_diff, struct, IS)
%disp_rate: m^2/s^3
IS(IS == 0) = [];
r0 = mean(IS);

%     S = interp1(struct(:,1), struct(:,2), r0) + 2 * interp1(struct(:,1), struct(:,3), r0);
    S = interp1(struct(:,1), struct(:,2), r0) * 11/3 / (4/3);
%     disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
    disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;

    t0 = CalT0(disp_rate, r0);
%     Vn = vel_diff / (S);
Vn = vel_diff/mean(vel_diff(1:5));
% Rn = R / (S);
    tn = (1:length(vel_diff))/4000/t0;
% tn = (1:length(R))/4000;
end

