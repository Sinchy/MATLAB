%particle tracking for 2D diffusion with no boundaries
clear all
% scrsz = get(0,'ScreenSize');
% figure('Position',[1 scrsz(4)/1.2 scrsz(3)/1.2 scrsz(4)/1.2])
figure('units','normalized','outerposition',[0 0 1 1])
%initial particle distribution at x=0.02,y=0.02;
%D is the diffusion coefficient, deltat is the time-step
%Np is the number of particles, Ntimes is the number of time steps
Np=50000;Ntimes=400;D=1;deltat=0.001/D;Dxx=D;Dyy=D/2;
%initial particle positions specified at x=0.0, y=0.0
xp=zeros(1,Np);yp=zeros(1,Np);
%initialize vectors for plotting moments
time=0;times=[0];xbar=[0];ybar=[0];varx=[0];vary=[0];
%time loop
for n=1:Ntimes
    time=time+deltat
    %the diffusive displacement is rescaled from 
    %either a standard normal, or from a uniform distribution with zero
    %mean and unit variance.  either way, after many steps the particle
    %position is normally distributed (central limit theorem)
    omega1=randn(1,Np)*sqrt(2*Dxx*deltat);
    omega2=randn(1,Np)*sqrt(2*Dyy*deltat);
    xp=xp+omega1;
    yp=yp+omega2;%if you make this omega1, you will see that you don't get the correct 2D diffusion
    %calculating spatial moments to make vectors for plotting
    %first calculate current centroids and variances
    xb=mean(xp);yb=mean(yp);vx=var(xp);vy=var(yp);
    %now augment arrays
    times=[times;time];xbar=[xbar;xb];ybar=[ybar;yb];varx=[varx;vx];vary=[vary;vy];
    %plots
    plot(xp,yp,'.','MarkerSize',2)
        axis equal
    xlim('manual')
    xlim([-5 5])
    ylim('manual')
    ylim([-5 5])
    pause(0.01)
end
%plotting moments
% figure('Position',[1 scrsz(4)/1.2 scrsz(3)/1.2 scrsz(4)/1.2])
% subplot(2,2,1)
% plot(times,xbar)
% ylim('manual')
% ylim([-5 5])
% xlabel('time'); ylabel('x-centroid')
% subplot(2,2,2)
% plot(times,ybar)
% ylim('manual')
% ylim([-5 5])
% xlabel('time'); ylabel('y-centroid')
% subplot(2,2,3)
% plot(times,varx)
% xlabel('time'); ylabel('x-variance')
% subplot(2,2,4)
% plot(times,vary)
% xlabel('time'); ylabel('y-variance')
% %estimating velocity and dispersion/diffusion coefficient
% p1=polyfit(times,xbar,1);velx=p1(1)
% p2=polyfit(times,ybar,1);vely=p2(1)
% p3=polyfit(times,varx,1);Diffxx=p3(1)/2
% p4=polyfit(times,vary,1);Diffyy=p4(1)/2

    