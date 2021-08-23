function [tn, Rn] = NormalizePairDispersion(veldiffmatrix_dissipat, R, IS, frame_rate)
%disp_rate: m^2/s^3
IS(IS == 0) = [];
r0 = mean(IS);

if isscalar(veldiffmatrix_dissipat)
    disp_rate = veldiffmatrix_dissipat;
     S = 2.1 * (disp_rate * mean(IS))^(2/3);
else 
    veldiff_matrix = veldiffmatrix_dissipat;
% %     S = interp1(struct(:,1), struct(:,2), r0) + 2 * interp1(struct(:,1), struct(:,3), r0);
%     S = interp1(struct(:,1), struct(:,2), r0) * 11/3 / (4/3);
% %     disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
%     disp_rate = (S / (11/3 * 2.1)) ^ (3/2) / r0 / 1e6;
    S = mean(nonzeros(veldiff_matrix(:, 1)));
% disp_rate = (S / ((41)^.5/3 * 2.1)) ^ (3/2) / (r0 /1e3) ;
% disp_rate = (S / (2.1)) ^ (3/2) / (r0 /1e3) ;
    disp_rate = (S / (2.1)) ^ (3/2) / (r0) ;
end


% t0 = CalT0(disp_rate, r0/1e3);
    t0 = CalT0(disp_rate, r0);
    Rn = R / (t0^2 * S);
% Rn = R / (S);
    tn = (1:length(R))/frame_rate/t0;
% tn = (1:length(R))/4000;
end

