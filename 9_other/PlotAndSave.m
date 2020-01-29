fig = figure;
for i = 1 : 96 * 2
    PlotTracks(tracks(tracks(:,5) > (i - 1) * 500 & tracks(:,5) < i * 500,:), fig);
     saveas(fig, ['/home/tanshiyong/Documents/Data/Single-Phase/11.03.17/Run1/LaVision/Figure/' num2str(i)], 'jpg');
    hold off;
end