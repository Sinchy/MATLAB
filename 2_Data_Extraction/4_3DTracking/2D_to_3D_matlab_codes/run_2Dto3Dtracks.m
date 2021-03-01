





start = 1:2000:30000;
last = 2000:2000:32000;

for i = 1:size(start,2)
    tr_numbers = start(i):last(i);
    if (exist('trackCluster') && exist('trackData') && exist('trackFit'))
        save 3Dtracks_with_fitting.mat trackCluster trackData trackFit
        clearvars -except i start last trackCluster trackData trackFit tr_numbers
            [trackCluster, trackData, trackFit] = ...
        From2Dto3DTracks_multiplecams(tr_numbers, trackCluster, trackData, trackFit);
        saveas(figure(1),'3Dtracks_with_fitting1.fig')
    else
    [trackCluster, trackData, trackFit] = ...
        From2Dto3DTracks_multiplecams(tr_numbers);
    end
end