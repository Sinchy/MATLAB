function HighStatisticConvergenceCheck(y)
figure;
h = histogram(y, 'Normalization', 'pdf');
yy = h.BinEdges;
pp = h.Values;
figure;
red = [1, 0, 0];
blue = [0.00,0.00,1.00];
colors_p = [linspace(red(1),blue(1),5)', linspace(red(2),blue(2),5)', linspace(red(3),blue(3),5)'];
for i = 1 : 5
    k = yy(2:end) .^ (i*2) .* pp;
    plot(yy(2:end), k/std(k), 'o', 'Color', colors_p(i, :), 'LineWidth', 2);
    hold on;
end
end

