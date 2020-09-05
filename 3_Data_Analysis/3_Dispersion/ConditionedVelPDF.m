function [S_small, S_large, S_avg] = ConditionedVelPDF(veldiff_matrix, frame_no)

vel_thred = 0.001;

% num_pair = size(veldiff_matrix);

ind = veldiff_matrix(:,frame_no) < vel_thred;
vel_small = veldiff_matrix(ind, frame_no + 1) - veldiff_matrix(ind, frame_no);
vel_large = veldiff_matrix(~ind, frame_no + 1) - veldiff_matrix(~ind, frame_no);
vel = veldiff_matrix(:, frame_no + 1) - veldiff_matrix(:, frame_no);

S_small = skewness(vel_small);
S_large = skewness(vel_large);
S_avg = skewness(vel);

figure;
% h = histogram((vel_small).^(1/2),'Normalization', 'pdf', 'Visible', 'off');
% semilogy(h.BinEdges(2:end) / mean(vel_small).^(1/2), mean(vel_small).^(1/2) * h.Values,  'LineWidth',2, 'Color', [1 0 0]);
h = histogram((vel_small),'Normalization', 'pdf', 'Visible', 'off');
semilogy(h.BinEdges(2:end) / std(vel_small), std(vel_small) * h.Values,  'LineWidth',2, 'Color', [1 0 0]);
% semilogy(h.BinEdges(2:end), h.Values,  'LineWidth',2, 'Color', [1 0 0]);
hold on;
% h = histogram((vel_large).^(1/2),  'Normalization', 'pdf', 'Visible', 'off');
% semilogy(h.BinEdges(2:end) / mean(vel_large).^(1/2), mean(vel_large).^(1/2) * h.Values,  'LineWidth',2, 'Color', [0 0 1]);
h = histogram((vel_large),  'Normalization', 'pdf', 'Visible', 'off');
semilogy(h.BinEdges(2:end) / std(vel_large), std(vel_large) * h.Values,  'LineWidth',2, 'Color', [0 0 1]);
% semilogy(h.BinEdges(2:end), h.Values,  'LineWidth',2, 'Color', [0 0 1]);
% vel = veldiff_matrix(:,2);
% h = histogram((vel).^(1/2),  'Normalization', 'pdf', 'Visible', 'off');
% % semilogy(h.BinEdges(2:end) / mean(vel).^(1/2), mean(vel).^(1/2) * h.Values,  'LineWidth',2, 'Color', [0 1 0]);
% semilogy(h.BinEdges(2:end), h.Values,  'LineWidth',2, 'Color', [0 1 0]);
h = histogram((vel),  'Normalization', 'pdf', 'Visible', 'off');
semilogy(h.BinEdges(2:end) / std(vel), std(vel) * h.Values,  'LineWidth',2, 'Color', [0 1 0]);
end