function PlotDispersion(R)
figure('OuterPosition',...
    [317.333333333333 173.333333333333 605 597.666666666667]);

% Create axes
axes1 = axes;
hold(axes1,'on');

% Create loglog
loglog((1:length(R))/4000,R,'DisplayName','Forward','LineWidth',2);

% Create ylabel
ylabel({'$R$'},'Interpreter','latex');

% Create xlabel
xlabel({'$t$ (s)'},'Interpreter','latex');

box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',20,'LineWidth',2,'XMinorTick','on','XScale','log',...
    'YMinorTick','on','YScale','log');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.293985385047778 0.710746460746462 0.264193367060146 0.123230373230373]);
end

