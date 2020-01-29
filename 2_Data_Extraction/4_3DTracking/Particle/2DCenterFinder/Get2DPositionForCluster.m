function [centers_OTF,resnorm] = Get2DPositionForCluster(img, N)
[Npxh, Npxw] = size(img);
centers_OTF0(1:N, 1) = 150;
centers_OTF0(:, 2) = 1.5;
centers_OTF0(:, 3) = 1.5;
centers_OTF0(:, 4) = randi([1 Npxw], [N, 1]);
centers_OTF0(:, 5) = randi([1 Npxh], [N, 1]);
% upper limit
up(1:N, 1) = 150;
up(:, 2) = 1.5;
up(:, 3) = 1.5;
up(:, 4) = Npxw;
up(:, 5) = Npxh;
%lower limit
lo(1:N, 1) = 150;
lo(:, 2) = 1.5;
lo(:, 3) = 1.5;
lo(:, 4) = 1;
lo(:, 5) = 1;

img = double(img);
[xData, yData, zData] = prepareSurfaceData( 1 : Npxw, 1 : Npxh, img );
xyData = {xData,yData};
[centers_OTF,resnorm] = lsqcurvefit(@ImageProjection,centers_OTF0,xyData,zData, lo, up);
% options.MaxFunEvals = 3000; 
% options = optimset('Display','iter','PlotFcns', fun);
% [centers_OTF,fval] = fminsearch(fun, centers_OTF0, options);

end

% function diff = ImageProjectionDifference(centers_OTF, img, N)
% [Npxh, Npxw] = size(img);
% 
% proj = zeros(Npxh, Npxw);
% for i = 1 : N
%     for x = 1 : Npxw
%         for y = 1 : Npxh
%             proj(y, x) = min(255, proj(y, x) + centers_OTF(i, 1) * exp(-(centers_OTF(i, 2) * (x - centers_OTF(i, 4)) ^ 2 + centers_OTF(i, 3) * (y - centers_OTF(i, 5)) ^ 2)));
%         end
%     end
% end
% diff = mean((proj - img) .^ 2, 'all') ^ 0.5;
% end

function proj = ImageProjection(centers_OTF, xy)
N = size(centers_OTF, 1);
proj = 0;
for i = 1 : N
    proj = min(255, proj + centers_OTF(i, 1) .* exp(-(centers_OTF(i, 2) .* (xy{1} - centers_OTF(i, 4)) .^ 2 + centers_OTF(i, 3) .* (xy{2} - centers_OTF(i, 5)) .^ 2)));
end
end