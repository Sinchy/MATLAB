function R = InscribedCircleRadius(tracks, center, r0)
% r0 = 5;
dR = 0.1;
n_p = size(tracks, 1);
n = 0;
i = 1;
R0 = r0;
dist = vecnorm(tracks(:, 1:3) - center, 2, 2);
while (n<n_p)
    R0 = R0 + dR;
    n = sum(dist < R0);
    rho(i) = n / (4/3 * pi * (R0) ^3);
    i = i + 1;
end

drho = rho(2:end) - rho(1:end-1);
ind_inc = drho > - 0.1;
r = r0 + 2*dR:dR:R0;
r_inc = r(ind_inc);
R = r_inc(end);
end

