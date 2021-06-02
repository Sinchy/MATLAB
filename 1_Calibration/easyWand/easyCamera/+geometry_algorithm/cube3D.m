function cube = cube3D(xAx, yAx, zAx)
xAx = reshape(xAx, numel(xAx), 1);
yAx = reshape(yAx, numel(yAx), 1);
zAx = reshape(zAx, numel(zAx), 1);

xel = length(xAx);
yel = length(yAx);
zel = length(zAx);

yzel = yel*zel;
yzPlane = zeros(yzel,2);
yidx = 1;
for y = 1:length(yAx)
    yzPlane(yidx:yidx+zel-1,:) = [repmat(yAx(y), zel,1) zAx];
    yidx = yidx+zel;
end

cube = zeros(xel*yel*zel, 3);
xidx = 1;
for x = 1:length(xAx)
    cube(xidx:xidx+yzel-1,:) = [repmat(xAx(x), yzel, 1), yzPlane];
    xidx = xidx + yzel;
end
