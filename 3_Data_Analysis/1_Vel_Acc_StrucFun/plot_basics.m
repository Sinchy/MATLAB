% plot_basics.m
% VARIABLES = "x [mm]" "y [mm]" "z [mm]" "u [m/s]" "v [m/s]" "w [m/s]" "|V| [m/s]" "I" "time step" "track id" "ax [m/s�]" "ay [m/s�]" "az [m/s�]" "|a| [m/s�]"
function plot_basics(data)
idx = ~isnan(data(:,4));

figure;
% mean_value = mean(data(:,12));
% deviation = std(data(:,12));
% xbins = mean_value - 4 * deviation : 8 * deviation / 100 : mean_value + 4 * deviation;
[h,f]=hist(data(:,12),100);
semilogy(f./std(data(idx,12)),h./trapz(f./std(data(idx,12)),h),'cs');
hold on;
h1 = chi2gof(data(:, 12))

% mean_value = mean(data(:,13));
% deviation = std(data(:,13));
% xbins = mean_value - 4 * deviation : 8 * deviation / 100 : mean_value + 4 * deviation;
[h,f]=hist(data(:,13),100);
semilogy(f./std(data(idx,13)),h./trapz(f./std(data(idx,13)),h),'ro');
h2 = chi2gof(data(:, 13))
% mean_value = mean(data(:,14));
% deviation = std(data(:,14));
% xbins = mean_value - 4 * deviation : 8 * deviation / 100 : mean_value + 4 * deviation;
[h,f]=hist(data(:,14),100);
semilogy(f./std(data(idx,14)),h./trapz(f./std(data(idx,14)),h),'b^');
h3 = chi2gof(data(:, 14))
xx=-6:0.1:6;
yy=exp(-xx.^2/2);
semilogy(xx,yy./trapz(xx,yy),'k--');
ylim([1e-6,1]);

xlabel('$u_i/u_{rms,i}$','fontsize',30,'fontname','Times New Roman','Interpreter','latex');
ylabel('$PDF$','fontsize',24,'fontname','Times New Roman','Interpreter','latex');
set(gca, 'LineWidth', 2.0 );
set(gca, 'fontsize', 24.0 );
set(gca, 'XMinorTick', 'on');
% set(gca, 'Ticklength', [0.02;0.01] );
set(gca, 'YMinorTick', 'on');
% set(gca, 'Ticklength', [0.02;0.01] );
% set(gca, 'XTick', [0.01 0.1 1 10] );
% set(gca, 'YTick', [0.01 0.1 1 10] );
h1 = findobj(gca,'Type','line');

set(h1, 'Markersize', 8);

set(h1, 'Linewidth', 2);
% axis([0.01 4 1e-2 20]);

leg = legend ('$u$','$v$','$w$','Gaussian fit');
set(leg,'Interpreter','latex'); 

%%
figure;
[h,f]=hist(data(:,9),100);
semilogy(f./std(data(idx,9)),h./trapz(f./std(data(idx,9)),h),'cs');
hold on;

[h,f]=hist(data(:,11),100);
semilogy(f./std(data(idx,11)),h./trapz(f./std(data(idx,11)),h),'ro');

[h,f]=hist(data(:,10),100);
semilogy(f./std(data(idx,10)),h./trapz(f./std(data(idx,10)),h),'b^');

xx=-10:0.1:10;
yy=exp(-xx.^2/2);
semilogy(xx,yy./trapz(xx,yy),'k--');
% norm = normpdf(f./std(data(idx,11)),0,1);
% semilogy(f./std(data(idx,11)),norm,'m--');
ylim([1e-5,1]);

xlabel('$a_i/a_{rms,i}$','fontsize',24,'fontname','Times New Roman','Interpreter','latex');
ylabel('$PDF$','fontsize',40,'fontname','Times New Roman','Interpreter','latex');
set(gca, 'LineWidth', 2.0 );
set(gca, 'fontsize', 24.0 );
set(gca, 'XMinorTick', 'on');
% set(gca, 'Ticklength', [0.02;0.01] );
set(gca, 'YMinorTick', 'on');
% set(gca, 'Ticklength', [0.02;0.01] );
% set(gca, 'XTick', [0.01 0.1 1 10] );
% set(gca, 'YTick', [0.01 0.1 1 10] );
h1 = findobj(gca,'Type','line');

set(h1, 'Markersize', 8);

set(h1, 'Linewidth', 2);
% axis([0.01 4 1e-2 20]);

leg = legend ('$a_x$','$a_y$','$a_z$','Gaussian fit');
set(leg,'Interpreter','latex'); 
end