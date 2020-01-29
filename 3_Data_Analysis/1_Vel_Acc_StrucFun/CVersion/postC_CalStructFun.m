corr = struct(:,13:16);
struct(struct(:,2) == 0, :) = [];
corr(corr(:,2) == 0, :) = [];

%%
% u_fluc = sqrt((std(velacc(:,12)).^2 + std(velacc(:,13)).^2 + std(velacc(:,14)).^2)/3); % mm
% u_fluc = u_fluc/1e3;          % m
% 
% ux_rms = rms(velacc(:,12))/1e3;
% uy_rms = rms(velacc(:,13))/1e3;
% uz_rms = rms(velacc(:,14))/1e3;

%%
e1 = struct(:,3);
e2 = struct(:,4);
e3 = struct(:,5);

e1_comp = (struct(:,3)./(2)).^(3/2)./(struct(:,1));
e2_comp = (struct(:,4)./(16/3)).^(3/2)./(struct(:,1));
e3_comp = (struct(:,5)./(-4/5))./(struct(:,1));
 %% Plot the structure functions
 
 figure;
    loglog(struct(:,1),e1./1e6,'r*-');
    hold on
    loglog(struct(:,1),e2./1e6,'k*-');
%     loglog(struct(:,1),e3,'b*-');
%     loglog(0.3:0.1:100, eps.*ones(998,1),'k--');  
%     xlim([0.3 100]);
%     ylim([0.01 0.4]);
    
    xlabel('$r$ (mm)','fontsize',30,'fontname','Times New Roman','Interpreter','latex');
    ylabel('$D_{LL} / D_{NN}$','fontsize',30,'fontname','Times New Roman','Interpreter','latex');
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

    leg1 = legend ('$D_{LL}$','$D_{NN}$','$D_{LLL}$');
    
    %% Plot the compensated structure functions
    figure;
    loglog(struct(:,1),e1_comp./1e6,'r*-');
    hold on
    loglog(struct(:,1),e2_comp./1e6,'k*-');
    loglog(struct(:,1),e3_comp./1e6,'b*-');
%     loglog(0.3:0.1:100, eps.*ones(998,1),'k--');  
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
    
    %% CORRELATION FUNCTIONS

    % Calulating f and g
    f_corr = (corr(:,3)./1e6)./u_fluc^2;
    g_corr = (corr(:,4)./1e6)./u_fluc^2;
    
    %% plot auto correlation functions
    figure; 
    tmp_x = corr(1:end,1);
    tmp_y = f_corr(1:end,1);
    plot(tmp_x,tmp_y,'rx-')
    hold on
    tmp_y = g_corr(1:end,1);
    plot(tmp_x,tmp_y,'k.-');

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
    % axis([0.01 4 1e-2 20]);

%     legend ('D_{LL}','D_{NN}','D_{LLL}');

    %% calculating integral length scales Ll and Ln from correlation function
     dummy = isfinite(f_corr);
     Ll = trapz(struct(dummy,1),f_corr(dummy))/100;
     dummy = isfinite(g_corr);
     Ln = trapz(struct(dummy,1),g_corr(dummy))/100;
     
     %% For isotropic flow G should match g_corr at all scales
     G = f_corr+((corr(:,1).*gradient(f_corr,corr(:,1)))/2);
     tmp_y = G(1:end);
     hold on; plot(tmp_x,tmp_y,'m-');
     

     %% CGVG data
     % Joint PDF of R and Q
     R = struct_CGVG_all(:,9);
     Q = struct_CGVG_all(:,10);
     
     x_axis = linspace(min(R),max(R),10);
     y_axis = linspace(min(Q),max(Q),10);
     
    % Compute corners of 2D-bins:
    [x_mesh_upper,y_mesh_upper] = meshgrid(x_axis(2:end),y_axis(2:end));
    [x_mesh_lower,y_mesh_lower] = meshgrid(x_axis(1:end-1),y_axis(1:end-1));

    % Compute centers of 1D-bins:
    x_centers = (x_axis(2:end)+x_axis(1:end-1))/2;
    y_centers = (y_axis(2:end)+y_axis(1:end-1))/2;
    
    % Compute pdf:
    pdf = mean( bsxfun(@le, R(:), x_mesh_upper(:).') ...
        & bsxfun(@gt, R(:), x_mesh_lower(:).') ...
        & bsxfun(@le, Q(:), y_mesh_upper(:).') ...
        & bsxfun(@gt, Q(:), y_mesh_lower(:).') );
    pdf = reshape(pdf,length(x_axis)-1,length(y_axis)-1); %// pdf values at the
    %// grid points defined by x_centers, y_centers
    pdf = pdf ./ (y_mesh_upper-y_mesh_lower) ./ (x_mesh_upper-x_mesh_lower);
    %// normalize pdf to unit integral

    %// Plot pdf
    figure
    imagesc(x_centers,y_centers,pdf)
    axis xy
    axis equal
    colorbar
    title 'pdf'