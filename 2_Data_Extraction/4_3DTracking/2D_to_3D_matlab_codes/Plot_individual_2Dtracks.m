function Plot_individual_2Dtracks(tr)
    
    [~,b] = histc(tr(:,1),unique(tr(:,1)));
    hold on
    for i = 1:max(b)
%         ind = tr(:,1) == i;
%         plot(tr(ind,2),tr(ind,3),'r.-');
        plot(tr(:,2),tr(:,3),'r.-');
    end
end