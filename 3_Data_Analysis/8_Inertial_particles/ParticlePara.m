function [tau_p, St, Fr, Sv_kol, Sv_l] = ParticlePara(rho_p, d_p, ul, disp_rate)
v = 0.9e-6;
tau_p = d_p^2 *(rho_p/1e3 - 1) / (18*v);
Sv_l = tau_p * 9.8 / ul;
[len_kol, t_kol, TL, Re_t, L] = FlowPara(disp_rate, ul);
% Sawford 2003
a_0 = 5 / (1 + 110 * Re_t^-1);
Fr = a_0 ^ .5 * ( disp_rate ^ 3 / v) ^ (1/4) / 9.8;
St = tau_p / t_kol;
Sv_kol = tau_p * 9.8 / (len_kol / t_kol);
end

