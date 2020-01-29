function a = GetOTFAlongXaxis(OTFParam, midpoints)
[X,Y,Z] = meshgrid(midpoints,midpoints,midpoints);
x = midpoints(1) : 0.1 :midpoints(end);
for i = 1 : length(x)
    a(i) = interp3(X, Y, Z, reshape(OTFParam{1}(1,:,:,:), [10,10,10]), 0, x(i), 0);
end
end

