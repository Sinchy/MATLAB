function t0 = CalT0(disp_rate, d0)
%d0 is the diameter of the eddy (mm)

t0 = disp_rate^(-1/3) * (d0/1000)^(2/3);

end

