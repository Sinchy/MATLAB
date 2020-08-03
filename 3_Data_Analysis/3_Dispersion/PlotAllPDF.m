figure;
axes1 = axes;
hold(axes1,'on');
set(gca, 'YScale', 'log')

frame = 1000;
dt = 250;
num_data = 15;
red = [1, 0, 0];
blue = [0.00,0.00,1.00];
colors_p = [linspace(red(1),blue(1),num_data)', linspace(red(2),blue(2),num_data)', linspace(red(3),blue(3),num_data)'];

% for i = 1 : num_data
%     d = disp_matrix{i};
%     disp = d(:, frame - dt/2 : frame + dt/2);
%     disp = nonzeros(disp(:));
%     h = histogram((disp).^(1/2), 20, 'Normalization', 'pdf', 'Visible', 'off');
%     h1 = semilogy(h.BinEdges(2:end) / mean(disp).^(1/2), mean(disp).^(1/2) * h.Values,  'LineWidth',2, 'Color', colors_p(i,:));
% end


for i = 1 : num_data
    d = disp_matrix{i};
    R = CalMeanFromTimeMatrix(d, 2);
    loglog(R, 'LineWidth',2, 'Color', colors_p(i,:));
%     disp = nonzeros(disp(:));
%     h = histogram((disp).^(1/2), 20, 'Normalization', 'pdf', 'Visible', 'off');
%     h1 = semilogy(h.BinEdges(2:end) / mean(disp).^(1/2), mean(disp).^(1/2) * h.Values,  'LineWidth',2, 'Color', colors_p(i,:));
end