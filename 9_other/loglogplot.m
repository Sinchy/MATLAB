figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.151358344113842 0.14306784660767 0.753641655886164 0.78193215339233]);
hold(axes1,'on');

% Create multiple lines using matrix input to loglog
loglog1 = loglog(taos,MSD(:, 1),'Marker','o','LineWidth',2,'Parent',axes1,...
    'Color',[1 0 1]);
set(loglog1(1),'Color',[0 0.447 0.741]);
% set(loglog1(2),'Marker','none','LineWidth',0.5);

% Create ylabel
ylabel({'$\sigma(\Delta_\tau x)^2 / \sigma(u_f)^2$ (s$^2$)'},...
    'Interpreter','latex');

% Create xlabel
xlabel({'$\tau$ (s)'},'Interpreter','latex');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.0001 10]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0.0001 0.0261227666474307]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',20,'LineWidth',2,'TickLength',[0.02 0.04],'XMinorTick',...
    'on','XScale','log','YMinorTick','on','YScale','log');