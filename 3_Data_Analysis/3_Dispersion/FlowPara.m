function [len_kol, t_kol, TL, Re, L] = FlowPara(disp_rate, ul)
v = 0.9e-6;
len_kol = (v^3/disp_rate)^(1/4);
t_kol = (v/disp_rate)^(1/2);
TL = ul^2/disp_rate;
Re = (TL/t_kol)^2;
L = Re^(3/4) * len_kol;
end

