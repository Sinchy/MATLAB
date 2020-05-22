function [exponent, dispersion_scaling] = LagrangianStrFunIntermittency(L0, disp_rate)
num_order = 10;
% p = 1:1:num_order;
exponent = zeros(num_order, 3);
dispersion_scaling = zeros(num_order, 3);

% parameter for Richardson fit
% para = [      0.000006468321075  -2.500000000000000   0.666666666666667
%    0.000041451416016  -1.500000000000000   1.000000000000000
%    0.000116107177905  -1.000000000000000   1.300000000000000
%    0.000242676525277  -0.700000000000000   1.600000000000000
%    0.000475938485406  -0.600000000000000   1.900000000000000];

%linear scale from 1 to 1.5, dispersion works!!
para = [         0.000108736519074  -6.959137216787811   1.000000000000000
   0.000759058352805  -7.249799510371584   1.125000000000000
   0.002303637880891  -7.637458427837277   1.250000000000000
   0.005018539270529  -8.121816303077411   1.375000000000000
   0.009154288265817  -8.703414485743236   1.500000000000000];

% parabolic increase
% para = [   0.000209662860058  -6.826924810425981   0.666666666666667
%    0.001339900913364  -6.752384682857895   0.750000000000000
%    0.002937560444114  -6.963106237868079   1.000000000000000
%    0.004897857805081  -8.304743049091540   1.416666666666667
%    0.007672875043324 -12.121212124655996   2.000000000000000];

%linear scale from .8 to 1.5
% para = [   0.000149994146623  -6.748205598933655   0.800000000000000
%    0.000898827570256  -6.918737147282138   0.975000000000000
%    0.002502676791274  -7.319475809931391   1.150000000000000
%    0.005179448264233  -7.916522492400772   1.325000000000000
%    0.009154288265817  -8.703414485743236   1.500000000000000];

%error function from 2/3 to 2
% para = [   
%    0.000159408863364  -6.747228940492305   0.771532804700190
%    0.000885620807272  -6.938289055538325   0.986333414791302
%    0.002173203548541  -7.949666301611606   1.333333333333333
%    0.004335177415237  -9.722490252769854   1.680333251875365
%    0.007890502086589 -11.242805507936286   1.895133861966477];

%linear scale from 1 to 1.6
% para = [0.000108736519074  -6.959137216787811   1.000000000000000
%    0.000741533863486  -7.319475803148023   1.150000000000000
%    0.002222174965234  -7.819656394956940   1.300000000000000
%    0.004808998841918  -8.458917944876214   1.450000000000000
%    0.008744332526160  -9.241290820838771   1.600000000000000];

% % scales from 2/3 to 2 for longer time 
% para = [        0.001030073631265  -6.826924810455107   0.666666666666667
%    0.004765411531258  -6.963106238151513   1.000000000000000
%    0.012325313863763  -7.949666301347544   1.333333333333333
%    0.025151315086058  -9.637438549488834   1.666666666666667
%    0.044748207099577 -12.121212121186009   2.000000000000000];
% del_u_0 = (disp_rate * L0) ^ (1/3);

% % scales from 0.65 to 2
% para = [      0.000209662860044  -6.826924810390576   0.666666666666667
%    0.002937560444232  -6.963106238176518   1.000000000000000
%    0.010061127539026  -7.949666301355805   1.333333333333333
%    0.023355496372770  -9.637438549488461   1.666666666666667
%    0.044748207099577 -12.121212121186009   2.000000000000000];

for p = 1:1:num_order
%     T0 = L0^(2/3) * disp_rate^(-1/3);
    uL = ((41/9)^.5 * 2.1 * (disp_rate * L0) ^ (2/3)) ^ .5;
    
    num_point = 5;
%     t = T0/10:T0/10:T0;
%     t = zeros(num_point, 1);
%     t = (100:200:1000)'/4000;
    t = (100:100:500)'/4000;
%     t = (170:(900 - 170)/4:900)'/4000;
    
    strFun = zeros(num_point, 1);
    dispersion = zeros(num_point, 1);
    fun = @(del_u, r, t, pm) RichardsonPDF(disp_rate, r, pm, t) .* del_u .^ p .* PDFVelocityIncrement(L0, disp_rate, r, del_u);
    dispersionfun = @(r, t, pm) r.^p .* RichardsonPDF(disp_rate, r, pm, t);
    for i = 1 : num_point
%         t(i) = T0  /num_point * i;

%         for j = 1 : 50
%             lgveldiff(i,j) = integral(@(r) fun(uL/50 * j, r, t(i), para(i, :)), 0, L0);
%             Euveldiff(i,j) =  PDFVelocityIncrement(L0, disp_rate, (0.55 * disp_rate * t(i)^3)^.5, uL/50 * j);
%         end
        strFun(i) = integral2(@(r, del_u) fun(del_u, r, t(i), para(i, :)), 0, inf, 0, inf);
        
        dispersion(i) = integral(@(r) dispersionfun( r, t(i), para(i, :)), 0, inf);
    end
    fp = CalculateScaling(t, strFun, 1);
    exponent(p, :) = fp;
    fp = CalculateScaling(t, dispersion, 1);
    dispersion_scaling(p, :) = fp;
end
 
end

function p = PDFVelocityIncrement(L0, disp_rate, r, del_u)
% p-model in P. Kailasnath, K.R. Sreenivasan 1993

%calculate the upper bond and lower bond of r for continuous interporation.
M = 0.3;

n_x = length(r);
% n_y = length(del_u);

p = zeros(1, n_x);
if isscalar(del_u)
   del_u = ones(1, n_x) * del_u; 
end
r(r > L0) = L0; % any separation larger than integral length scale would be the same Gaussian.
for i = 1 :  n_x
    if r(i) < L0 * .9
        n = ceil(log(L0 / r(i)) / log(2));
        r_lo = L0 / 2 ^ n;
        del_u_0 = (disp_rate * L0) ^ (1/3);
    %     del_u_0 = ((41/9)^.5 * 2.1 * (disp_rate * L0) ^ (2/3)) ^ .5 /1000;
        p_lo = 0;
        for k = 0 : n
            sigma = del_u_0 * M ^ (k/3) * (1 - M) ^ ((n - k)/3);
            p_lo = p_lo + nchoosek(n, k) * 2 ^ (-n) / (2 * pi * sigma ^ 2 ) ^ .5 * exp(- del_u(i) .^ 2 / (2 * sigma ^ 2));
        end

        n = floor(log(L0 / r(i)) / log(2));
        r_up = L0 / 2 ^ n;

        if r_lo == r_up
            p(i) = p_lo;
            continue;
        end

        p_up = 0;
        for k = 0 : n
            sigma = del_u_0 * M ^ (k/3) * (1 - M) ^ ((n - k)/3);
            p_up = p_up + nchoosek(n, k) * 2 ^ (-n) / (2 * pi * sigma ^ 2 ) ^ .5 * exp(- del_u(i) .^ 2 / (2 * sigma ^ 2));
        end

        p(i) = interp1([r_lo r_up], [p_lo p_up], r(i));
    else
        sigma = (disp_rate * r(i)) ^ (1/3);
        p(i) = 1 / (2 * pi * sigma ^ 2 ) ^ .5 * exp(- del_u(i) .^ 2 / (2 * sigma ^ 2));
    end

end
end

function p = RichardsonPDF(disp_rate, r, para, t)
% Richardson model in Ott and Mann 2000
% g = 0.55;
C = 1;
% B = 100;
g = 0.55;
r_sqmn = g * disp_rate * t^3; % unit: m/s
% r_sqmn = r_sqmn * 1e6;
% r = r *1e3; % change the unit to mm
% tn = t/T0;

% p = C * r.^2 / (35/3 * (2*pi/143)^(3/2) * r_sqmn^(3/2)) .* exp(-(1287/8 * (r / r_sqmn^.5)).^(2/3));
% p = C * 2 * pi * r.^2 / (r_sqmn^(3/2)) .* exp(-(1287/8 * (r / r_sqmn^.5)).^(2/3));
% p = 2 * pi * r.^2 / (r_sqmn^(3/2)) .* exp(- 2.5 * (r / r_sqmn^.5).^(2/3));
% p = exp( -1 - b * (r / r_sqmn^.5).^(alpha) );
% p = C * 2 * pi * r.^2 / (r_sqmn^(3/2)) .* exp(b *( (r / r_sqmn^.5)).^(alpha));
% p = C * r.^2 / r_sqmn^(3/2) .* exp(- B * (r / r_sqmn^.5).^(2/3));
% p = 1.2 .* exp(-2.6 * (r / r_sqmn^.5).^(2/3));

%% fitting Richardson form PDF manually
% a = 969.3*tn^2 - 280.6*tn + 22.44;
% b = 6.288*tn^3 - 13.92*tn^2 + 10.7*tn - 3.531;
% c = 1.789*tn + 0.48;
% p = a / (r_sqmn^(3/2)) .* exp(b * (r / r_sqmn^.5).^(c));

%% log normal fit. not working. t^3 scaling not seen and more obvious intermittency 
% mu = 1.062*tn - 1.218;
% sigma =  - 0.5711*tn + 1.392; 
% 
% x = r / r_sqmn^.5;
% p = 1 ./ (x * sigma * (2 * pi)^.5) .* exp(- (log(x) - mu).^2 / (2 * sigma^2));

%% fitting Richardson form PDF manually and using only the fitting time


% p =  para(1) / (r_sqmn^(3/2)) .* exp( para(2) * (r / r_sqmn^.5).^para(3));

p = para(1) / (t^(9/2)) .* exp( para(2) * (r / t^(3/2)).^para(3));

end