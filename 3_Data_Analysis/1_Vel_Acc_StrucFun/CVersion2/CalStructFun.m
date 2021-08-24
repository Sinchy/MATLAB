function [statistics_struct, statistics_corr] = CalStructFun(datapath, framerate, redges_lin, redges_log, save_name, filter_data_path)

addpath 1-Basics/   2-EStruct/;
if ~exist('filter_data_path', 'var')
    [filter_data, ~] = ashwanth_rni_vel_acc(datapath, 6, 14, framerate);
%     filter_data=sortrows(filter_data,4); % sort the data to make it prepared for function rni_findpairs
else
    load(filter_data_path); % load data directly
%     filter_data=sortrows(file.filter_data,4); % sort the data to make it prepared for function rni_findpairs
end

% using map to get the data in order to save memory
    fileID = fopen([datapath save_name 'filter_data_bin.mat'], 'w');
    fwrite(fileID, filter_data, 'double'); % save the data
    fclose(fileID); 
    [row, col] = size(filter_data);
    % map a variable is to save memory and enable to get more workers for
    % parallelization
     data_map = memmapfile([datapath save_name 'filter_data_bin.mat'], 'Format',{'double',[row col],'tracks'}); 
     
% redges_lin = 0.1:0.3:60; % tunnel 0.1:0.5:100, tank:0.1:1:300
% redges_log = 10.^(0:0.05:4); %10.^(-1:0.05:2)  tank:10.^(-1:0.05:2.5)
%% fluctuation velocity

u_fluc = sqrt((std(filter_data(:,12)).^2 + std(filter_data(:,13)).^2 + std(filter_data(:,14)).^2)/3); % mm
u_fluc = u_fluc/1e3;          % m

ux_rms = rms(filter_data(:,12))/1e3;
uy_rms = rms(filter_data(:,13))/1e3;
uz_rms = rms(filter_data(:,14))/1e3;

s_log = size(redges_log,2)-1;
s_lin = size(redges_lin,2)-1;

filter_data = []; % clear the data
%% STRUCTURE FUNCTIONS
    [statistics_struct, statistics_corr] = rni_findpairs(data_map, redges_log, redges_lin);
    %% Energy dissipation rate from DLL and DLLL
s_log = size(redges_log,2)-1;
    e1 = (statistics_struct(:,1)./statistics_struct(:,4)./2).^(3/2)./redges_log(1:s_log)';
    e2 = (statistics_struct(:,2)./statistics_struct(:,4)./(16/3)).^(3/2)./redges_log(1:s_log)';
    e3 = (statistics_struct(:,3)./statistics_struct(:,4)./(-4/5))./redges_log(1:s_log)';  
    
    figure;
    loglog(redges_log(1:s_log),e1/1e6,'r*-');
    hold on
    loglog(redges_log(1:s_log),e2/1e6,'k*-');
    loglog(redges_log(1:s_log),e3/1e6,'b*-');
    loglog(0.3:0.1:100, eps.*ones(998,1),'k--');  
%     xlim([0.3 100]);
%     ylim([0.01 0.4]);
    
    xlabel('$r$ (mm)','fontsize',30,'fontname','Times New Roman','Interpreter','latex');
    ylabel('$\epsilon (m^2/s^3)$','fontsize',30,'fontname','Times New Roman','Interpreter','latex');
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

    leg1 = legend ('$(D_{LL}/C_2)^{3/2}/r$','$(D_{NN}/4C_2/3)^{3/2}/r$','$(-5/4)D_{LLL}/r$');
    set(leg1,'Interpreter','latex'); 

%     %% integral length scale and taylor Reynolds num
% %     eps = 0.136; % peak of the figure
%     l = u_fluc^3/eps;
%     Re_taylor = sqrt(15*u_fluc*l/1e-6);
% 
%     n1 = statistics_struct(:,1)./(1e6.*statistics_struct(:,4).*(redges_log(1:s_log)'.*eps./1e3).^(2/3));
%     n2 = statistics_struct(:,2)./(1e6*2*statistics_struct(:,4).*(redges_log(1:s_log)'.*eps./1e3).^(2/3));
% 
%     len_Kol = (1e-18/eps)^0.25; % (nu^3/eps)^(1/4)
%     time_Kol = (1e-6/eps)^0.5; % (nu^3/eps)^(1/4)

    %% Plot of C2 from DLL and DNN
%     figure;
%     semilogx(redges_log(1:s_log)./len_Kol,n1,'r.-');
%     % semilogx(redges(1:40)./eta_KolLength,n1,'r.-');
%     hold on
%     semilogx(redges_log(1:s_log)./len_Kol,n2*3/4,'k.-');
%     % semilogx(redges(1:40)./eta_KolLength,n2,'k.-');
%     xlabel('r/\eta');
%     ylabel('D_{XX}/(\epsilon * r)^{2/3}');
%     legend ('D_{LL}', 'D_{NN}');

%% CORRELATION FUNCTIONS

    %% Calulating f and g
    f_corr = (statistics_corr(:,1)/1e6)./(statistics_corr(:,3).*u_fluc^2);
    g_corr = (statistics_corr(:,2)/1e6)./(2*statistics_corr(:,3).*u_fluc^2);

    figure; plot(redges_lin(2:s_lin),f_corr(2:end),'rx-', redges_lin(2:s_lin),g_corr(2:end),'k.-');

    xlabel('$r$ (mm)','fontsize',24,'fontname','Times New Roman','Interpreter','latex');
    ylabel('$<u(x)u(r+x)>/u^2$','fontsize',24,'fontname','Times New Roman','Interpreter','latex');
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
    axis([0.01 4 1e-2 20]);

    legend ('D_{LL}','D_{NN}','D_{LLL}');

    %% calculating Ll and Ln
     dummy = isfinite(f_corr);
     Ll = trapz(redges_lin(dummy),f_corr(dummy))/100;
     dummy = isfinite(g_corr);
     Ln = trapz(redges_lin(dummy),g_corr(dummy))/100;
     
     %%
     G = f_corr+((redges_lin(1:s_lin)'.*gradient(f_corr,redges_lin(1:s_lin)))/2);
%      hold on; plot(redges_lin(1:s_lin),G,'m-');
     mkdir([datapath 'StructFunc']);
%      save([datapath 'structfunction.mat'], 'statistics_struct', 'statistics_corr', 'e1', 'e2', 'e3', 'f_corr', 'g_corr', 'Ll', 'Ln', 'G', '-v7.3');
     save([datapath 'StructFunc/SF' save_name '.mat'],  'statistics_struct', 'statistics_corr', 'e1', 'e2', 'e3',...
 'f_corr', 'g_corr', 'Ll', 'Ln', 'G', 'u_fluc', 'ux_rms', 'uy_rms', 'uz_rms', 's_log', 's_lin', 'redges_lin', 'redges_log', '-v7.3');
    
end
