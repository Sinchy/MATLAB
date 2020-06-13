function [exponent, dispersion_scaling, r_samples, u_samples] = MontCarloLagrangianStrFunIntermittency(L0, disp_rate)
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
% 
% para = [   0.000931490397065  -8.199999999999999   0.666666666666667
%    0.006141251092015 -11.000000000000000   1.100000000000000
%    0.022018876730331 -14.500000000000000   1.300000000000000
%    0.053585852439819 -24.000000000000000   1.600000000000000
%    0.118327304538820 -50.000000000000000   1.900000000000000];

% para = [   0.000707612132825  -6.826924682990786   0.666666666666667
%    0.004169235666947  -7.184097032129471   1.100000000000000
%    0.013667553766076  -7.799345551129893   1.300000000000000
%    0.028927481460558  -8.892602388934517   1.600000000000000
%    0.049484200113351  -8.640834749933591   1.900000000000000];


% para = [   0.000707612152472  -6.826924810287321   0.666666666666667
%    0.004169257426725  -7.184139014142215   1.100000000000000
%    0.013693124208903  -7.819656192542954   1.300000000000000
%    0.029512122309353  -9.241290942154862   1.600000000000000
%    0.060422920941796 -13.943252514853253   1.900000000000000];

%linear
% para = [      0.000707612152472  -6.826924810287321   0.666666666666667
%    0.004664737186938  -6.963106238227814   1.000000000000000
%    0.013391360485564  -7.949666043580308   1.333333333333333
%    0.028726239150002  -9.637438541136660   1.666666666666667
%    0.052628249737272 -12.121212117840663   2.000000000000000];

%inverse parabolic
% para = [   0.000707612152472  -6.826924810287321   0.666666666666667
%    0.003658091634974  -7.637458428468133   1.250000000000000
%    0.011328777549800  -9.637438493706112   1.666666666666667
%    0.026470016720220 -11.415433457028840   1.916666666666667
%    0.052628249737272 -12.121212117840663   2.000000000000000];

%parabolic
% para = [
%    0.000707612152472  -6.826924810287321   0.666666666666667
%    0.007181031456222  -6.752384682644013   0.750000000000000
%    0.018101355994015  -6.963106074050821   1.000000000000000
%    0.032285683780993  -8.304743055469356   1.416666666666667
%    0.052628249737272 -12.121212117840663   2.000000000000000];

% scale 1-2
% para = [   0.000367195055532  -6.963106238227813   1.000000000000000
%    0.003658091634974  -7.637458428468133   1.250000000000000
%    0.012184357681802  -8.703414485742554   1.500000000000000
%    0.027867363373170 -10.177027636471843   1.750000000000000
%    0.052628249737272 -12.121212117840663   2.000000000000000];

% shorter time
% para = [   0.000209662860058  -6.826924810425981   0.666666666666667
%    0.000870388279778  -6.963106238230461   1.000000000000000
%    0.002173203548541  -7.949666301611606   1.333333333333333
%    0.004357876874160  -9.637438549921200   1.666666666666667
%    0.007672875043324 -12.121212124655996   2.000000000000000];

% scales from 1 to 1.5
para = [         0.000108736519074  -6.959137216787811   1.000000000000000
   0.000759058352805  -7.249799510371584   1.125000000000000
   0.002303637880891  -7.637458427837277   1.250000000000000
   0.005018539270529  -8.121816303077411   1.375000000000000
   0.009154288265817  -8.703414485743236   1.500000000000000];

% scales from 1 to 1.6 consistent with experiment
% para = [   0.004664737186827  -6.963106238038367   1.000000000000000
%    0.008446534169134  -7.319475809453568   1.150000000000000
%    0.013693124437456  -7.819656394677117   1.300000000000000
%    0.020635488306015  -8.458917242864379   1.450000000000000
%    0.029512122280717  -9.241290921465527   1.600000000000000];

% scales from 0.65 to 2
% para = [      0.000209662860044  -6.826924810390576   0.666666666666667
%    0.002937560444232  -6.963106238176518   1.000000000000000
%    0.010061127539026  -7.949666301355805   1.333333333333333
%    0.023355496372770  -9.637438549488461   1.666666666666667
%    0.044748207099577 -12.121212121186009   2.000000000000000];

num_samples = 10000;
% del_u_0 = (disp_rate * L0) ^ (1/3);

    num_point = 5;
%     t = T0/10:T0/10:T0;
%     t = zeros(num_point, 1);
%     t = (150:200:1050)'/4000;
% t = (150:200:1050)'/4000;
% t = (350:(750-350)/4:750)'/4000;
t = (100:100:500)'/4000;
% t = (100:200:1000)'/4000;
%     strFun = zeros(num_point, 1);
%     dispersion = zeros(num_point, 1);
% uL = ((41/9)^.5 * 2.1 * (disp_rate * L0) ^ (2/3)) ^ .5;
uL = ((disp_rate * L0) ^ (2/3)) ^ .5 ;


r_samples = zeros(num_samples, num_point);
u_samples = zeros(num_samples, num_point);
    for i = 1 : num_point
%         t(i) = T0  /num_point * i;

%% generate samples for r at time t(i)
        rr = 0:L0/100:L0*4;
        pp_r = RichardsonPDF(disp_rate, rr, para(i,:), t(i));
        r_samples(:, i) = randpdf(pp_r, rr, [num_samples 1]);
        
        %% Eulerian velocity PDF
        uu = 0:uL/100:uL * 4;
    
        
        for j = 1 : num_samples
            pp_u = PDFVelocityIncrement(L0, disp_rate, r_samples(j, i), uu);
            u_samples(j, i) = randpdf(pp_u, uu, [1 1]);
        end
%         for j = 1 : 50
% %             lgveldiff(i,j) = integral(@(r) fun(uL/50 * j, r, t(i), para(i, :)), 0, L0);
%             Euveldiff(i,j) =  PDFVelocityIncrement(L0, disp_rate, (0.55 * disp_rate * t(i)^3)^.5, uL/50 * j);
%         end
%         strFun(i) = integral2(@(r, del_u) fun(del_u, r, t(i), para(i, :)), 0, L0, 0, Inf);
        
%         dispersion(i) = integral(@(r) dispersionfun( r, t(i), para(i, :)), 0, L0);
    end


for p = 1:1:num_order

    strFun_p = mean(u_samples .^p);
    dispersion_p = mean(r_samples .^p);
    fp = CalculateScaling(t, strFun_p', 1);
    exponent(p, :) = fp;
    fp = CalculateScaling(t, dispersion_p', 1);
    dispersion_scaling(p, :) = fp;
end
 
end

function p = PDFVelocityIncrement(L0, disp_rate, r, del_u)
% p-model in P. Kailasnath, K.R. Sreenivasan 1993

%calculate the upper bond and lower bond of r for continuous interporation.
M = 0.3;

% n_x = length(r);
n_y = length(del_u);

p = zeros(1, n_y);
if isscalar(r)
   r = ones(1, n_y) * r; 
end
r(r > L0 ) = L0; % any separation larger than integral length scale would be the same Gaussian.
for i = 1 :  n_y
    if r(i) < L0 * 1
    n = ceil(log(L0 / r(i)) / log(2));
    r_lo = L0 / 2 ^ n;
    del_u_0 = (disp_rate * L0) ^ (1/3);
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
% C = 1;
% B = 100;
% g = 0.55;
% r_sqmn = g * disp_rate * t^3; % unit: m/s
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