% @author: Maziar Raissi

function plot_isosurface_griddata(x_star, y_star, z_star, u_star, xlab, ylab, zlab, tit)

x_l = min(x_star);
x_r = max(x_star);

y_l = min(y_star);
y_r = max(y_star);

z_l = min(z_star);
z_r = max(z_star);

nn = 100;
x = linspace(x_l, x_r, nn)';
y = linspace(y_l, y_r, nn)';
z = linspace(z_l, z_r, nn)';
[Xplot, Yplot, Zplot] = meshgrid(x,y,z);


Uplot = griddata(x_star,y_star,z_star, u_star, Xplot,Yplot,Zplot);

idx = linspace(min(u_star),max(u_star),5);

isosurface(Xplot, Yplot, Zplot, Uplot, idx(2));
hold all
isosurface(Xplot, Yplot, Zplot, Uplot, idx(3));
hold all
isosurface(Xplot, Yplot, Zplot, Uplot, idx(4));
zlim([idx(1), idx(5)])
view(3)
xlabel(xlab);
ylabel(ylab);
zlabel(zlab);
title(tit);

axis tight
axis equal
colormap jet
colorbar
alpha(0.7)
set(gca,'FontSize',20);
set(gcf, 'Color', 'w');