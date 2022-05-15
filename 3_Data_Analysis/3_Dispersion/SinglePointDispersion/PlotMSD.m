function PlotMSD(MSD, dir, error_shadow)
if ~exist('error_shadow', 'var')
    error_shadow = 0;
end
length = size(MSD, 1);
frame_rate = 5000;
t = [1:length]/frame_rate;
% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.167591564927858 0.172147655103031 0.737408435072142 0.752852344896971]);
hold(axes1,'on');
plot(t, MSD(:,dir))
if (error_shadow)
    ci(:, 1) = MSD(:, dir) - MSD(:, dir + 3);
    ci(:, 2) = MSD(:, dir) + MSD(:, dir + 3);
    ind = ci(:,1) > 0;
    hold on
     patch([t(ind), fliplr(t(ind))], [ci(ind, 1)', fliplr(ci(ind, 2)')], [0 0 1], 'FaceAlpha', .5, 'EdgeColor', 'none');
    % patch([t, fliplr(t)], [ci(:, 1)', fliplr(ci(:, 2)')], [0 0 1], 'FaceAlpha', .5, 'EdgeColor', 'none');
end
% Create ylabel
ylabel({'$\sigma(\Delta_\tau x)^2$ (mm$^2$)'},'Interpreter','latex');

% Create xlabel
xlabel({'$\tau$ (s)'},'Interpreter','latex');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.0001 0.1]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',20,'LineWidth',2,'XMinorTick','on','XScale','log',...
    'YMinorTick','on','YScale','log');
% set(axes1,'FontSize',20,'LineWidth',2,'XMinorTick','on',...
%     'YMinorTick','on');
end

