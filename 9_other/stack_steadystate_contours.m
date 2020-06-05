%contours on the x-z plane and ground-level concentrations based on
%steady-state 
x=0:1:250;z=0:1:50;H=10;
D=1;mdot=(4*pi)^1.5;u=3;
c=zeros(length(x),length(z));cground=zeros(length(x));
% scrsz = get(0,'ScreenSize');
% figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])
figure('units','normalized','outerposition',[0 0 1 1])
    for i=1:length(x)
        for j=1:length(z)
            xx=x(i);zz=z(j);
            c(i,j)=mdot/(4*pi*xx*D)*(exp(-(zz-H)^2*u/4/D/xx)+exp(-(zz+H)^2*u/4/D/xx));
            end
    end
    subplot(2,1,1)
   [C,h]=contour(x,z,c',[0 0.005 0.01 0.02 0.05 0.1 0.2 0.5 1 2 3])%0.001 0.002
   %contourf(x,y,c,[1 0.5 0.2 0.1 0.05 0.02 0.01 0.005 0.002 0.001])
   %surf(x,y,c)
   colormap (jet)
   set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
   %zlim('manual')
    %zlim([0 1]);
    daspect([1 1 4])
    title('concentration contours on centerline')
   %axis ([min(x) max(x) min(y) max(y) -0.1 1])
   subplot(2,1,2)
   plot(x,c(:,1),'LineWidth',2)
   grid on
   xlim('manual')
   xlim([0 250]);
   ylim('manual')
   ylim([0 0.05])
   title('ground level concentration')
    %pause(0.01)