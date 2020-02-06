function [MSD, MSDl, MSDu, datapoints] = MSDCurve(tracks, taos, framerate)
% taos stores the points that need to be calculated on the curve
len = length(taos);
MSD = zeros(len, 3);
MSDl = MSD;
MSDu = MSD;
datapoints = zeros(len, 1);
% for single-phase
% vel = vecnorm(tracks(:, 6:8), 2, 2);
% delta_vel = var(vel);

% for bubble
% delta_vel = 3.2783e4; % variance of fluid velocity

for i = 1 : len
    round(i/len * 100)
    [msd, ci, dp, ~] = MeanSquareDisplacement(tracks, round(taos(i) * framerate));
    if ~isempty(msd)
        MSD(i, :) = msd;
        MSDl(i, :) = ci(1, :);
        MSDu(i, :) = ci(2, :);
        datapoints(i) = dp;
    else
        disp(['No tracks found longer than ' num2str(taos(i)) 's']);
        taos(i:end) = [];
        MSD(i:end, :) = [];
        MSDl(i:end, :) = [];
        MSDu(i:end, :) = [];
        datapoints(i:end) = [];
        break;
    end
end
%     MSD = MSD ./ delta_vel; 
%     MSDl = MSDl ./ delta_vel; 
%     MSDu = MSDu ./ delta_vel; 
%     loglog(taos, MSD(:, 1));
%     hold on
%     loglog(taos, MSDl(:,1), '-m');
%     loglog(taos, MSDu(:,1), '-m');
%     
    % Create figure
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
ylabel({'$\sigma(\Delta_\tau x)^2$'},...
    'Interpreter','latex');

% Create xlabel
xlabel({'$\tau$'},'Interpreter','latex');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.0001 10]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0.0001 0.0261227666474307]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',20,'LineWidth',2,'TickLength',[0.02 0.04],'XMinorTick',...
    'on','XScale','log','YMinorTick','on','YScale','log');
end

