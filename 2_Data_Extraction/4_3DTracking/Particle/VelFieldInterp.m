function vel_interp = VelFieldInterp(pos3D, vel, midpoints)
[nx, ny, nz, ~] = size(vel);
[X,Y,Z] = meshgrid(midpoints,midpoints,midpoints);
for i = 1 : 3
    vel_interp(i) = interp3(X, Y, Z, reshape(vel(:, :, :, i), [nx, ny, nz]), pos3D(2), pos3D(1), pos3D(3));
end
end

