function found = CompareParticles(particle0, particle1, div_radii)
tol = 0.1;
found = zeros(size(particle0, 1), 1);
for i = 1 : size(particle0, 1)
    dist = vecnorm(particle1 - particle0(i, :), 2, 2);
    [min_dist, I] = min(dist);
    if min_dist < tol
        found(i) = I;
    elseif min_dist < tol * 20
        if div_radii(i) < 0.1
            found(i) = I;
        end
    end
end
end

