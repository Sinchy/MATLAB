for i = 247:300
velgrad(:,(i - 1)*npoints/300 + 1 : i*npoints/300) = getVelocityGradient(authkey, dataset, 1, FD4Lag4, 'None', npoints / 300, points(:, (i - 1)*npoints/300 + 1 : i*npoints/300));
end