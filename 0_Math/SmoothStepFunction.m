function y = SmoothStepFunction(x_min, x_max, y_min, y_max, x)
x = Clamp((x - x_min) / (x_max - x_min), 0, 1);
y = x ^ 3 * (x * (6 * x - 15) + 10);
y = y_min + y * (y_max - y_min);
end

function x = Clamp(x, x_min, x_max)
if (x < x_min) 
    x = x_min;
end
if (x > x_max)
    x = x_max;
end

x = x;

end

