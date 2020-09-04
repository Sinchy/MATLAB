function PlotDispPDF(disp_matrix, frame)
% num_frame = size(disp_matrix, 2);
num_frame = length(frame);
% df = floor(num_frame / num_sect);
dt = [50 100 150 200 250];
% dt = [0 0 0 1 1 1 1 1 1 1];
% dt = 50;
% dt = 0;
% dt = 200;
figure;
axes1 = axes;
hold(axes1,'on');
set(gca, 'YScale', 'log')
hold on
Markers = {'v','o','>','+','*','x','d','^','s','<','.'};
red = [1, 0, 0];
blue = [0.00,0.00,1.00];
colors_p = [linspace(red(1),blue(1),num_frame)', linspace(red(2),blue(2),num_frame)', linspace(red(3),blue(3),num_frame)'];
% colors_p = [linspace(red(1),blue(1),9)', linspace(red(2),blue(2),9)', linspace(red(3),blue(3),9)'];

% P = zeros(num_frame, 3);
for i = 1 : num_frame
    disp = disp_matrix(:, frame(i)- dt(i)/2 : frame(i) + dt(i)/2);
    disp = nonzeros(disp(:));
%     disp = disp .^ .5;
%     [cn, cr] = hist((disp / (mean(disp))).^(1/3), 50);
%     h = histogram((disp / (mean(disp))).^(1/2), 10.^[-10:.1:2], 'Normalization', 'pdf', 'Visible', 'off');
% h = histogram((disp / (mean(disp))).^(1/2), 0:0.1:8, 'Normalization', 'probability', 'Visible', 'off');
%     [cn, cr] = hist((disp / (mean(disp))).^(1/2), 15);
    h = histogram((disp).^(1/2),  'Normalization', 'pdf', 'Visible', 'off');
%     h = histogram((disp).^(1/2),10.^[-10:0.1:2], 'Normalization', 'probability', 'Visible', 'off');
%     [cn, cr] = hist((disp / (mean(disp))), 0:.5:10);
%     [cn, cr] = hist((disp).^(1/2) / 1e3, 15);
%     [cn, cr] = hist((disp / (mean(disp))).^(1/2), 10.^[-3:0.05:1]);
%     [cn, cr] = hist((disp / (mean(disp .^ 2))^.5), 10.^[-2:0.1:1]);
%     cn = cn / sum(cn);
%     P_n = (mean(disp)) .^ (3/2) * cn ./ (4 * pi * cr .^2);
%     pks_p = findpeaks(cn, 'MinPeakHeight',0.06);
%     [cn, cr] = ksdensity((disp / (mean(disp))).^(1/2), 10.^[-2:0.1:1]);
%     pks_p(i) = max(cn);
%     pks(i) = cr(cn == max(cn) );
%       cr_m(i) = MeanOfcertainProbability(cn, cr, 0.6);
%     xx = cr .^ (1/3);
%     xx = h.BinEdges;
%     yy = cn / sum(cn);
%     yy = mean(disp) ^ (3/2) * cn / sum(cn);
%     yy = mean(disp) ^ (3/2) *h.Values;
%     yy = h.Values;
    
%     h1 = semilogy(xx(2:end), yy, Markers{ceil(10 * rand(1,1))}, 'LineWidth',2);
%      h1 = loglog(xx(2:end), yy, Markers{ceil(10 * rand(1,1))}, 'LineWidth',2);

%     x = (cr(1:end - 1) + cr(2:end))/2;
%      h1 = semilogy(cr, cn, Markers{i}, 'LineWidth',2, 'Color', colors_p(i,:));
%       set(h1, 'markerfacecolor', get(h1, 'color'), 'LineWidth',1);
      h1 = semilogy(h.BinEdges(2:end) / mean(disp).^(1/2), mean(disp).^(1/2) * h.Values, Markers{i}, 'LineWidth',2, 'Color', colors_p(i,:));
% h1 = semilogy(h.BinEdges(2:end) ,  h.Values, Markers{i}, 'LineWidth',2, 'Color', colors_p(i,:));
% h1 = semilogy(h.BinEdges(2:end) / mean(disp).^(1/2), h.Values, Markers{i}, 'LineWidth',2, 'Color', colors_p(i,:));
%       h1 = semilogy(h.BinEdges(2:end) / mean(disp.^2)^.5, mean(disp.^2)^.5 * h.Values, Markers{i}, 'LineWidth',2, 'Color', colors_p(i,:));
%       h1 = semilogy(h.BinEdges(2:end) / mean(disp.^2)^.5,  h.Values, Markers{i}, 'LineWidth',2, 'Color', colors_p(i,:));
      set(h1, 'markerfacecolor', get(h1, 'color'), 'LineWidth',1);
      
      %% curve fitting
% %       fun_log = @(p,x) p(1) + p(2) * x .^ p(3);
%         dp_sm = mean(disp);
%         fun_log = @(p,x) log(2*pi* x.^2 /dp_sm ^ (1/2)) + p(1) * (x) .^ p(2);
%         
%       cr(cn == 0) = [];
%       cn(cn == 0) = [];
%       if length(cr) >= 81
%           len = 81;
%       else
%           len = length(cr) - 1;
%       end
% %       x = (cr(1:len) + cr(2:len+1))/2;
%       
%       p = lsqcurvefit(fun_log, [ -0.5 1], cr(1:len), log(cn(1:len)));
%       P(i,:) = p;
%       cn_log = log(2*pi* cr.^2 /dp_sm ^ (1/2)) + p(1) * (cr) .^ p(2);
%       hold on
%       plot(cr, exp(cn_log), 'Color', colors_p(i, :), 'LineWidth', 1);

%% PDF fitting
dp_sm = mean(disp);
% pf_Richardson = @(r, a, b, c)  a / (dp_sm^(3/2)) .* exp( b * (r / dp_sm^.5).^c);
t = (frame(i) + dt(i)/2) *.02;
pf_Richardson = @(r, a, b, c)  a / (t^(9/2)) .* exp( b * (r / t^(3/2)).^c);
% 
% i = i;

% [para,para_CI] = mle(disp.^.5, 'pdf',pf_Richardson, 'start',[pi/2 -2.5 2/3], 'LowerBound', [0 -Inf, 0],'UpperBound', [Inf 0, 2], 'Optimfun','fmincon');

end
% Create ylabel
ylabel({'$\langle \Delta r ^2 \rangle)^{1/2} p(\Delta r, t)$'},'Interpreter','latex');

% Create xlabel
xlabel({'$(\Delta r^2/ \langle \Delta r ^2 \rangle)^{1/2}$'},...
    'Interpreter','latex');

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',20,'LineWidth',2,'YMinorTick','on','YScale','log');
end

% function cr_m = MeanOfcertainProbability(cn, cr, probability)
% 
% cn_max = max(cn);
% 
% prob = 0;
% cn_m = cn_max / 2;
% cn_low = 0;
% cn_up = cn_max;
% 
% while(abs(prob - probability) > 0.01)
%     if abs(cn_up - cn_low) < 1e-3
%         break;
%     end
%     cn_m = (cn_low + cn_up) / 2;
%     cn_series = cn(cn > cn_m);
%     prob = sum(cn_series) / sum(cn);
%     if prob < probability
%         cn_up = cn_m;
%     else
%         cn_low = cn_m;        
%     end
%     
% end
% cr_series = cr(cn > cn_m);
% cr_m = dot(cr_series , cn_series) / sum(cn_series);
% end

