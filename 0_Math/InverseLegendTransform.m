function [f, x] = InverseLegendTransform(g, p)

% x(p) = g'(p)
x_p = diff(g) ./ diff(p);

% f(x) =g(p) + x(p) *p
p_2 = (p(1:end-1) + p(2:end))/2;
g_2 = (g(1:end-1) + g(2:end))/2;
f_x_p = g_2 - x_p .* p_2;

x = x_p;
f = f_x_p;  

end

