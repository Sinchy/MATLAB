load('VSC_all.mat')

for icam=1:6
xx=camall(icam).R*[1;1;1];
xx=[xx,zeros(3,1)];
plot3(xx(1,:),xx(2,:),xx(3,:),'-');hold all;
text(xx(1,1),xx(2,1),xx(3,1),['cam' num2str(icam)]);
end