function x = SolveVelSlope(n, disp_rate, kol_len, Re)
D0 = n * kol_len; %initial separation
u_D0_s = (disp_rate * D0) ^ (2/3); % velocity2 at D0
L = Re ^ (3/4) * kol_len; % integral length scale
u_L_s = (disp_rate * L)^(2/3); % u'2
T_L = L / u_L_s ^ (1/2); % integral time scale
t_kol = T_L/Re^(1/2);
C_1 = 0.15; % prefactor
a_D0_s =  disp_rate ^ (4/3) / D0 ^ (2/3);
% a_D0_s = 2000;

%% using fsolve
P = [u_D0_s, u_L_s, T_L, a_D0_s];
fun = @(x) Condition(P, x);
% x = [t*, k, C2];
x = fsolve(fun,[t_kol 1 0]);
x = real(x);

% %% using vpasolve
% syms t_s k C2
% assume(t_s >= t_kol & t_s < T_L); assume(k <= 1 & k > 0);
% assumptions
% f1 = u_D0_s + a_D0_s * t_s ^ 2 == t_s ^ k + C2;
% f2 = 2 * a_D0_s * t_s == k * t_s ^ (k - 1);
% f3 = u_D0_s + a_D0_s * t_s ^ 2 + (T_L - t_s) ^ k + C2 == u_L_s;
% 
% [sol_t, sol_k, sol_C2] = vpasolve(f1, f2, f3, t_s, k, C2);
% 
% x = [sol_t, sol_k, sol_C2];

% %% using lsqnonlin
% P = [u_D0_s, u_L_s, T_L, a_D0_s];
% fun = @(x) Condition(P, x);
% [x,resnorm,~,exitflag] = lsqnonlin(fun,[t_kol 1 0], [t_kol, 0 0], [T_L 1 u_L_s]);

t = 0:.01:T_L - x(1);
u_s = zeros(length(t),1);
for i = 1 : length(t)
    if t(i) < x(1)
        u_s(i) = u_D0_s + a_D0_s * t(i) ^ 2;
    else
        u_s(i) = t(i) ^ x(2) + x(3);
    end
end
figure;
plot(t, u_s);
end

function F = Condition(P, x)
x = real(x);
F(1) = P(1) + P(4) * (x(1)) ^ 2 - x(1) ^ x(2) - x(3);
F(2) = 2 * P(4) * (x(1)) - x(2) * x(1) ^ (x(2) - 1);
F(3) = P(1) + P(4) * (x(1)) ^ 2 + (P(3) - x(1)) ^ x(2) + x(3) - P(2);
% F = norm(F);
end
