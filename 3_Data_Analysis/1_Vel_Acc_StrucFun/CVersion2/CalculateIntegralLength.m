function L = CalculateIntegralLength(x, f)
ft = fit(x, f, 'exp1');
x = 1:100;
y = ft(x);
hold on
plot(x, y)
L = - ft.a/ft.b;
end

