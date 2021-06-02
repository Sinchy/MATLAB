function VelProfile(velacc)
% max_l = max(velacc(:, 1:3), [], 'all');
% min_l = min(velacc(:, 1:3), [], 'all');
% dl = (max_l - min_l) / 10;
 direction = 'XYZ';

for dir1 = 1:3
    max_l = max(velacc(:, dir1));
    min_l = min(velacc(:, dir1));
    dl = (max_l - min_l) / 10;
    [~, uxy, uidx] = histcounts(velacc(:,dir1), min_l : dl : max_l);
    uxy = (uxy(1:end - 1) + uxy(2:end)) / 2;
% [~, ~, uidx] = unique(idx, 'rows');
avgv1 = accumarray(uidx, velacc(:,6), [], @nanmean);
avgv2 = accumarray(uidx, velacc(:,7), [], @nanmean);
avgv3 = accumarray(uidx, velacc(:,8), [], @nanmean);
mean_map = [uxy', avgv1, avgv2, avgv3];

stdv1 = accumarray(uidx, velacc(:,6), [], @nanstd);
stdv2 = accumarray(uidx, velacc(:,7), [], @nanstd);
stdv3 = accumarray(uidx, velacc(:,8), [], @nanstd);
std_map = [uxy', stdv1, stdv2, stdv3];

figure(dir1)
errorbar(mean_map(:,1),mean_map(:,2)./1e3,std_map(:,2)./1e3./sqrt(1),'ro-','LineWidth',2.0,'MarkerSize',10.0);
hold on
errorbar(mean_map(:,1),mean_map(:,3)./1e3,std_map(:,3)./1e3./sqrt(1),'bo-','LineWidth',2.0,'MarkerSize',10.0);
errorbar(mean_map(:,1),mean_map(:,4)./1e3,std_map(:,4)./1e3./sqrt(1),'ko-','LineWidth',2.0,'MarkerSize',10.0);

xlabel([direction(dir1) ' (mm)'],'fontsize',30,'fontname','Times New Roman','Interpreter','latex');
ylabel('$u_{mean}$ (m/s)','fontsize',30,'fontname','Times New Roman','Interpreter','latex');
set(gca, 'LineWidth', 2.0 );
set(gca, 'fontsize', 24.0 );
set(gca, 'XMinorTick', 'on');
set(gca, 'YMinorTick', 'on');
xlim([-30 30])
ylim([-.5 .5])
% legend('u','v','w')        
end

for dir1 = 1:3
    max_l = max(velacc(:, dir1));
    min_l = min(velacc(:, dir1));
    dl = (max_l - min_l) / 10;
    [~, uxy, uidx] = histcounts(velacc(:,dir1), min_l : dl : max_l);
    uxy = (uxy(1:end - 1) + uxy(2:end)) / 2;
% [~, ~, uidx] = unique(idx, 'rows');
avgv1 = accumarray(uidx, velacc(:,12), [], @nanmean);
avgv2 = accumarray(uidx, velacc(:,13), [], @nanmean);
avgv3 = accumarray(uidx, velacc(:,14), [], @nanmean);
mean_map = [uxy', avgv1, avgv2, avgv3];

stdv1 = accumarray(uidx, velacc(:,12), [], @nanstd);
stdv2 = accumarray(uidx, velacc(:,13), [], @nanstd);
stdv3 = accumarray(uidx, velacc(:,14), [], @nanstd);
std_map = [uxy', stdv1, stdv2, stdv3];

        figure(dir1)
        errorbar(mean_map(:,1),mean_map(:,2)./1e3,std_map(:,2)./1e3./sqrt(1),'r^--','LineWidth',2.0,'MarkerSize',10.0);
        hold on
        errorbar(mean_map(:,1),mean_map(:,3)./1e3,std_map(:,3)./1e3./sqrt(1),'b^--','LineWidth',2.0,'MarkerSize',10.0);
        errorbar(mean_map(:,1),mean_map(:,4)./1e3,std_map(:,4)./1e3./sqrt(1),'k^--','LineWidth',2.0,'MarkerSize',10.0);

        xlabel([direction(dir1) ' (mm)'],'fontsize',30,'fontname','Times New Roman','Interpreter','latex');
        ylabel('$u$ (m/s)','fontsize',30,'fontname','Times New Roman','Interpreter','latex');
        set(gca, 'LineWidth', 2.0 );
        set(gca, 'fontsize', 26.0 );
        set(gca, 'XMinorTick', 'on');
        set(gca, 'Ticklength', [0.03;0.01] );
        set(gca, 'YMinorTick', 'on');
        set(gca, 'Ticklength', [0.03;0.01] );

        xlim([min_l max_l])
        ylim([-.5 .5])
        
%         leg=legend('$\langle u_1 \rangle$','$\langle u_2 \rangle$','$\langle u_3 \rangle$','$u_1$','$u_2$','$u_3$');
leg=legend('$u_1$','$u_2$','$u_3$');
        set(leg,'Interpreter','latex')
        set(leg, 'fontsize', 18.0 ); 
        set(leg, 'box','off');
        set(leg,'NumColumns',3)
        ytickvals=[ -.5  -.25  0  .25  .5 ];
end
end

