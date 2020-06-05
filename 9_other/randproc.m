clear all; close all
%simple AR1 random process generator
%AR1 = auto-regressive order 1
y=zeros(10001,1);
y(1)=randn(1);%random initial value
r=0.5;%try r = 0.2, 0.5, 0.9, -0.5 to explore sensitivity
for i=1:10000
    y(i+1,1)=r*y(i,1)+sqrt(1-r^2)*randn(1);%y_i+1 =r* y_i+sqrt(1-r^2)*a random part
end
dummy=1:200;%just to give me an x-axis for plotting
figure('units','normalized','outerposition',[0 0.5 1 0.5])
plot(dummy,y(1:200,1),dummy,y(201:400,1),dummy,y(9001:9200,1),dummy,zeros(200,1),'k')
title('Three chunks or realizations of the random process')
%determine statistics
%the AR1 model was set up above to produce zero mean and unit variance
mu=mean(y);
sig2=var(y);
figure
%autocovariance function
%I am calculating the sample autocovariance function based on a large
%number of pairs (9000) and comparing to the theoretical autocovariance r^s
for ilag=1:50
    cov(ilag)=sum(y(1:9000,1).*y(1+ilag:9000+ilag,1))/9000;
end
s=0:50;
plot(s,[sig2 cov],s,sig2*r.^s)
title('comparison of theoretical and sample autocovariance function up to lag s = 50')