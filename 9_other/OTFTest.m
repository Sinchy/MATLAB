para = [150 0 1.2 1.2 2.5 3.5];
for i = 1 : 5
    for j = 1 : 5
        z(i, j) = uint8( integral2(@(x, y)gaussian2D(para, x, y), i - .5, i + .5, j - .5, j + .5));
    end
end
x = 1 : 5;
y = 1 : 5;
[xData, yData, zData] = prepareSurfaceData( x, y, z );

xyData = {xData,yData};
%% Set up the startpoint
[amp, ind] = max(zData); % amp is the amplitude.
xo = xData(ind); % guess that it is at the maximum
yo = yData(ind); % guess that it is at the maximum
ang = 0; % angle in radians.
sx = 0.5;
sy = 0.5;
% zo = median(zData(:))-std(zData(:));
xmax = max(xData)+0.5;
ymax = max(yData)+0.5;
xmin = min(xData)-0.5;
ymin = min(yData)-0.5;

%% Set up fittype and options.
% Lower = [0, 0.0001, 0, 0, xmin, ymin, 0];
% Upper = [255,pi/2+0.0001, 3, 3, xmax, ymax, Inf]; % angles greater than 90 are redundant
% StartPoint = [amp, ang, sx, sy, xo, yo, zo];%[amp, sx, sxy, sy, xo, yo, zo];

Lower = [0, 0.0001, 0, 0, xmin, ymin];
Upper = [255,pi/2+0.0001, 3, 3, xmax, ymax]; % angles greater than 90 are redundant
StartPoint = [amp, ang, sx, sy, xo, yo];%[amp, sx, sxy, sy, xo, yo, zo];

tols = 1e-16;
% options = optimset('Display','off',...
%     'MaxFunEvals',5e2,...
%     'MaxIter',5e2,...
%     'TolX',tols,...
%     'TolFun',tols,...
%     'TolCon',tols );
options = optimset('Display','off','TolFun',tols,'LargeScale','off');
%% perform the fitting
 results1 = lsqcurvefit(@gaussian2DV2,StartPoint,xyData,zData,Lower,Upper,options);
 results2 = lsqcurvefit(@GaussianIntegration,StartPoint,xyData,zData,Lower,Upper,options);
 
 function z = GaussianIntegration(par, xy)
z = zeros(size(xy{1}, 1), 1);
for i = 1 : size(xy{1}, 1)
    z(i) = integral2(@(x, y)gaussian2D(par, x, y), xy{1}(i) - .5, xy{1}(i) + .5, xy{2}(i) -.5, xy{2}(i) + .5);
end
end
 
 function z = gaussian2DV2(par,xy)
% compute 2D gaussian
xx=(xy{1}-par(5)).*cos(par(2))+(xy{2}-par(6)).*sin(par(2));
yy=-(xy{1}-par(5)).*sin(par(2))+(xy{2}-par(6)).*cos(par(2));
% z = par(7) + ...
%     par(1)*exp(-(xx.^2/(2*par(3)^2)+yy.^2./(2*par(4)^2)));
z = par(1)*exp(-(xx.^2 * par(3) + yy.^2 * par(4)));
end

function z = gaussian2D(par,x, y)
% compute 2D gaussian
xx=(x-par(5)).*cos(par(2))+(y-par(6)).*sin(par(2));
yy=-(x-par(5)).*sin(par(2))+(y-par(6)).*cos(par(2));
% z = par(7) + ...
%     par(1)*exp(-(xx.^2/(2*par(3)^2)+yy.^2./(2*par(4)^2)));
z = par(1)*exp(-(xx.^2 * par(3) + yy.^2 * par(4)));
end