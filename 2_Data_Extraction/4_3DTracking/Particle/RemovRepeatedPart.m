function particles = RemovRepeatedPart(particles)
repeated = zeros(size(particles, 1), 1);
for i = 1 : size(particles, 1)
    if ~repeated(i, 1)
        diff = vecnorm(particles(i, 1:3) - particles(:, 1:3), 2, 2);
        ind = diff < 0.04;
        repeated(ind,1) = 1;
        repeated(i,1) = 0;
    end
end
particles(repeated == 1, :) = [];
end

