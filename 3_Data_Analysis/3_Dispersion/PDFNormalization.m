%a / (dp_sm^(3/2)) .* exp( b * (r / dp_sm^.5).^c);
% t = (150:200:1050)/4000;

% t = (170:(900 - 170)/4:900)'/4000; % make the time much smaller than TL to minimize the error in the integration
t = (100:200:1000)'/4000;
dp_theo = 0.55*.075*t.^3;

L0 = 0.01;

exp_min = 2/3;
exp_max = 2;

%assume linear increase
exp_p = exp_min: (exp_max-exp_min)/4 : exp_max;

% inverse parabolic increase
% exp_p = -1/12 * ([1:5] - 5).^2 + 2;

% parabolic increase
% exp_p = 1/12 * ([1:5] - 1).^2 + 2/3;

% assume error function
% exp_p = (exp_max - exp_min) / 2 * (erf(1/2 * ([1:5] - 1) - 1) + 1) + exp_min;

figure
axes1 = axes;
hold on

for i = 1 : 5
    
% dp_sm = dp_theo(i);
% dp_sm = dp(i);
a_f = para(i, 1);
b_f = para(i, 2);
% c = para(i, 3);
c = exp_p(i);
syms r
PDF0_rs = @(r) r.^2 * a_f / (t(i)^(9/2)) .* exp( b_f * (r / t(i)^(3/2)).^c);
rs0(i) = vpaintegral(PDF0_rs, r, 0, inf);

% syms r a b
% PDF = @(r, a) a / (dp_sm^(3/2)) .* exp( b * (r / dp_sm^.5).^c);

eqn1 = @(p) integral(@(r) p(1) / (t(i)^(9/2)) .* exp( p(2) * (r / t(i)^(3/2)).^c), 0, inf) - 1;
eqn2 = @(p) integral(@(r) r.^2 * p(1) / (t(i)^(9/2)) .* exp( p(2) * (r / t(i)^(3/2)).^c), 0, inf) - 0.55 * 0.075 * t(i)^3;

sltn = fsolve(@(p) [eqn1(p), eqn2(p)], [para(i, 1) para(i, 2)]);
para_1(i,:) = sltn;
% PDF = @(r, a, b) a / (t(i)^(9/2)) .* exp( b * (r / t(i)^(3/2)).^c);
% Dp = @(r, a, b) r.^2 * a / (t(i)^(9/2)) .* exp( b * (r / t(i)^(3/2)).^c);
% assume(a>0)
% assume(b<0)
% % p = int(@(x) PDF(x, pi), 0, inf);
% eqn = [int(PDF, r, 0, L0) == 1, int(Dp, r, 0, L0) == 0.55 * 0.075 * t(i)^3];
% sltn = solve(eqn);
% para_1(i) = double(sltn)
% PDF_s = @(r) para_1(i) / (dp_sm^(3/2)) .* exp( b * (r / dp_sm^.5).^c);
PDF_s = @(r) sltn(1) / (t(i)^(9/2)) .* exp( sltn(2) * (r / t(i)^(3/2)).^c);
p_c = vpaintegral(PDF_s, r, 0, inf)
rr = 0:.0001:L0;
pp = PDF_s(rr);
plot(rr/(0.55*0.075*t(i)^3)^(1/2) , pp);
% PDF_rs = @(r) r.^2 * double(sltn) / (dp_sm^(3/2)) .* exp( b * (r / dp_sm^.5).^c);
PDF_rs = @(r) r.^2 * sltn(1) / (t(i)^(9/2)) .* exp( sltn(2) * (r / t(i)^(3/2)).^c);
rs(i) = vpaintegral(PDF_rs, r, 0, inf)
end
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',20,'LineWidth',2,'YMinorTick','on','YScale','log');

