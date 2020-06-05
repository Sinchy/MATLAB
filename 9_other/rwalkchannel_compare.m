%this version was shared with class in Spring 2020
clear all; close all
%setting plot size
figure('units','normalized','outerposition',[0 0 1 1])
%particle tracking for 1D diffusion between walls at 0, 1
%initial particle distribution equally spaced from 0 to 1 (uniformly
%distributed along y), and all starting at x=0
%D is the diffusion coefficient, deltat is the time-step
%Np is the number of particles, Ntimes is the number of time steps
Np=10000;Ntimes=500;D=1e-3;deltat=1;u=0.1;%u is the 
yp=linspace(0.0,1,Np);yp1=yp;yp2=yp;%3 cases being simulated
xp=zeros(1,Np);xp1=xp;xp2=xp;%3 cases being simulated
%i is a simple array that denotes particle number
i=1:1:Np;
%time loop
for n=1:Ntimes
    %the diffusive displacement is obtained from 
    %either a standard normal, or from a uniform distribution with zero
    %mean and unit variance.  either way, after many steps the particle
    %position is normally distributed (central limit theorem)
    up=4*yp.*(1-yp)*u;up2=4*yp2.*(1-yp2)*u;%advection velocity at particle's location (vectorized)
    %xp=xp+up*deltat+(-sqrt(3)+2*sqrt(3)*rand(1,Np))*sqrt(2*D*deltat);%uniform dist
    %yp=yp+(-sqrt(3)+2*sqrt(3)*rand(1,Np))*sqrt(2*D*deltat);%uniform dist
    xp=xp+up*deltat+sqrt(2*D*deltat)*randn(1,Np);%this is for normal dist
    yp=yp+sqrt(2*D*deltat)*randn(1,Np);%this is for normal dist
    %reflection at walls y=0 and y=1 using MATLAB's logical indexing
    yp(yp>1)=2-yp(yp>1);
    yp(yp<0)=-yp(yp<0);
    %
    %second case - constant advection velocity
    ubar=2/3*u;
    xp1=xp1+ubar*deltat+sqrt(2*D*deltat)*randn(1,Np);
    yp1=yp1+sqrt(2*D*deltat)*randn(1,Np);%y diffusion is included but of little consequence
    %third case uses velocity profile, but has no y diffusion (yp2 is not
    %updated)
    xp2=xp2+up2*deltat+sqrt(2*D*deltat)*randn(1,Np);
    %plots
    subplot(3,1,1)
    %first plot shows particle position
    %shear dispersion case
    plot(xp,yp,'.','MarkerSize',5)
    %plot()
    %ylim('manual')
    %ylim([0 1])
    xlim('manual')
    xlim([0 Ntimes*u*deltat])
    %constant advection case
    subplot(3,1,2)
    plot(xp1,yp1,'.','Markersize',5)
    xlim('manual')
    xlim([0 Ntimes*u*deltat])
    ylim('manual')
    ylim([0 1])
 %no y diffusion case
    subplot(3,1,3)
     plot(xp2,yp2,'.','Markersize',5)
    xlim([0 Ntimes*u*deltat])
    pause(0.1)
end
%make a new figure with particle positions binned along x to produce the
%equivalent of width-averaged concentration distributions
figure
edges=0:u*deltat:Ntimes*u*deltat;%define bin locations along x
plot(edges,histc(xp1,edges));
hold on
plot(edges,histc(xp,edges),'k')
hold on
plot(edges,histc(xp2,edges),'r')
    