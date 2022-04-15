%% get the tracks with radius within 0.1~0.2mm
trID = r_mm(r_mm(:,2) >= 0.1 & r_mm(:, 2) <= .2, :);
tracks_fl = tracks(ismember(tracks(:,5), trID), :);

%% get the tracks with radius > 0.2mm
trID = r_mm( r_mm(:, 2) > .2, :);
tracks_fl = tracks(ismember(tracks(:,5), trID), :);

%% calculate the RDF
xbins = 2 * 10.^[-1:.05:1];
[g, g_f, r] = RDF(tracks_fl, xbins, 10000);

%%
save('C:\Users\ShiyongTan\Documents\Data_processing\20220204\T3\results\RDF\RDF_bubble0.2+mm.mat', 'g', 'g_f', 'r')
%%
figure
% r_mean = mean(r_mm(r_mm(:,2) >= 0.1 & r_mm(:, 2) <= .2, 2));
r_mean = mean(r_mm(r_mm(:,2) >= 0.2 , 2));
loglog(r / r_mean,g, 'MarkerFaceColor',[0 0 1],'Marker','o','LineStyle','none', 'Color',[0 0 1]);

%% plot shaded confident interval
for i = 1 : size(g_f, 2)
    pd = fitdist(g_f(:, i), 'Normal');
    pa =  paramci(pd);
    ci(i,:) = pa(:,1)';
end
%%
hold on
patch([r / r_mean, fliplr(r / r_mean)], [ci(:, 1)', fliplr(ci(:, 2)')], [0 0 1], 'FaceAlpha', .5, 'EdgeColor', 'none');