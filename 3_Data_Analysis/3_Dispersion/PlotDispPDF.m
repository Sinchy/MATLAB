function [cr_m] = PlotDispPDF(disp_matrix, frame)
% num_frame = size(disp_matrix, 2);
num_frame = length(frame);
% df = floor(num_frame / num_sect);
dt =10;
figure;
axes1 = axes;
hold(axes1,'on');
set(gca, 'YScale', 'log')
hold on
Markers = {'v','o','>','+','*','x','d','^','s','<'};
red = [1, 0, 0];
pink = [0.00,0.00,1.00];
colors_p = [linspace(red(1),pink(1),10)', linspace(red(2),pink(2),10)', linspace(red(3),pink(3),10)'];
P = zeros(num_frame, 3);
for i = 1 : num_frame
    disp = disp_matrix(:, frame(i) : frame(i) + dt);
    disp = nonzeros(disp(:));
%     disp = disp .^ .5;
%     [cn, cr] = hist((disp / (mean(disp))).^(1/3), 50);
%     h = histogram((disp / (mean(disp))).^(1/2), 10.^[-10:.1:2], 'Normalization', 'pdf', 'Visible', 'off');
% h = histogram((disp / (mean(disp))).^(1/2), 0:0.1:8, 'Normalization', 'probability', 'Visible', 'off');
%     [cn, cr] = hist((disp / (mean(disp))).^(1/2), 0:0.05:8);
    [cn, cr] = hist((disp / (mean(disp))).^(1/2), 10.^[-2:0.1:1]);
%     cn = cn / sum(cn);
%     pks_p = findpeaks(cn, 'MinPeakHeight',0.06);
%     [cn, cr] = ksdensity((disp / (mean(disp))).^(1/2), 10.^[-2:0.1:1]);
%     pks_p(i) = max(cn);
%     pks(i) = cr(cn == max(cn) );
      cr_m(i) = MeanOfcertainProbability(cn, cr, 0.6);
%     xx = cr .^ (1/3);
%     xx = h.BinEdges;
%     yy = cn / sum(cn);
%     yy = mean(disp) ^ (3/2) * cn / sum(cn);
%     yy = mean(disp) ^ (3/2) *h.Values;
%     yy = h.Values;
    
%     h1 = semilogy(xx(2:end), yy, Markers{ceil(10 * rand(1,1))}, 'LineWidth',2);
%      h1 = loglog(xx(2:end), yy, Markers{ceil(10 * rand(1,1))}, 'LineWidth',2);

%      h1 = semilogy(cr, cn, Markers{i}, 'LineWidth',2, 'Color', colors_p(i,:));
%       set(h1, 'markerfacecolor', get(h1, 'color'), 'LineWidth',1);
      
%       fun_log = @(p,x) p(1) + p(2) * x .^ p(3);
%       cr(cn == 0) = [];
%       cn(cn == 0) = [];
%       if length(cr) >= 81
%           len = 81;
%       else
%           len = length(cr);
%       end
%       p = lsqcurvefit(fun_log, [1; 1; 1], cr(1:len), log(cn(1:len)));
%       P(i,:) = p;
end
% % Create ylabel
% ylabel({'$p(\Delta r, t)$'},'Interpreter','latex');
% 
% % Create xlabel
% xlabel({'$(\Delta r^2/ \langle \Delta r ^2 \rangle)^{1/2}$'},...
%     'Interpreter','latex');
% 
% box(axes1,'on');
% % Set the remaining axes properties
% set(axes1,'FontSize',20,'LineWidth',2,'YMinorTick','on','YScale','log');
end

function cr_m = MeanOfcertainProbability(cn, cr, probability)

cn_max = max(cn);

prob = 0;
cn_m = cn_max / 2;
cn_low = 0;
cn_up = cn_max;

while(abs(prob - probability) > 0.01)
    if abs(cn_up - cn_low) < 1e-3
        break;
    end
    cn_m = (cn_low + cn_up) / 2;
    cn_series = cn(cn > cn_m);
    prob = sum(cn_series) / sum(cn);
    if prob < probability
        cn_up = cn_m;
    else
        cn_low = cn_m;        
    end
    
end
cr_series = cr(cn > cn_m);
cr_m = dot(cr_series , cn_series) / sum(cn_series);
end

