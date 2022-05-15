function St = StokesNumber(d, u_b, u_l, tau)
% d: bubble diameter, u_b: bubble velocity; u_l: liquid velocity; tau:
% komogorov time scale.
nu = 9e-7;
Re_b = (u_b - u_l) * d / nu;
tau_b = (d/2)^2 * (1 + .16 * Re_b^.5) / (6 * nu);
St = tau_b / tau;
end

