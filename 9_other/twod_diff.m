%c=zeros(201,201);
%x=-100:1:100;y=-100:1:100;
figure('units','normalized','outerposition',[0 0 1 1])
x=-25:1:250;y=-25:1:25;
c=zeros(length(x),length(y));
for time=0.001:0.1:20
    for i=1:length(x)
        for j=1:length(y)
    c(i,j)=1/time*exp(-(x(i)-3*time)^2/4/time-(y(j))^2/4/time);
    %c(length(x),length(y))=1;
        end
    end
   contourf(x,y,c')%,[0 0.001 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.5 1])
   %contourf(x,y,c,[1 0.5 0.2 0.1 0.05 0.02 0.01 0.005 0.002 0.001])
   %surf(x,y,c)
   colormap (jet)
   zlim('manual')
    zlim([0 1]);
    daspect([1 1 1])
   %axis ([min(x) max(x) min(y) max(y) -0.1 1])
    pause(0.05)
end