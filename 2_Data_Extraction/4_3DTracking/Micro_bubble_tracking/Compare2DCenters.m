function found = Compare2DCenters(center0, center1)
tol = 2;
found = zeros(size(center0, 1), 1);
for i = 1 : size(center0, 1)
    dist = vecnorm(center1 - center0(i, :), 2, 2);
    [min_dist, I] = min(dist);
    if min_dist < tol
        found(i) = I;
    end
end
end

