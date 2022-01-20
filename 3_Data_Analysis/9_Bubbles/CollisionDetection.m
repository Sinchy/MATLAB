function collision = CollisionDetection(tracks, radius)
frame_NO = unique(tracks(:, 4));
num_frame = length(frame_NO);
r_max = max(radius(:,2));
collision = [];
wpix = 0.02;
tol = 5 * wpix;

for i = 1 : num_frame
    frame = tracks(tracks(:,4) == frame_NO(i), :);
    num_particles = size(frame, 1);
    for j = 1 : num_particles
        particle = frame(j, :);
        r_p = radius(radius(:, 1) == particle(:, 5), 2);
        particles_to_compare = frame(j + 1:end, :);
        dist = vecnorm(particle(1:3) - particles_to_compare(:, 1:3), 2, 2);
        ind = dist < (r_p + r_max) * wpix;
        if sum(ind) == 0
            continue;
        end
        candidates = particles_to_compare(ind, :);
        dist = dist(ind);
        for k = 1 : size(candidates, 1)
            r_candidates = radius(radius(:, 1) == candidates(k, 5), 2);
            if (r_candidates + r_p) * wpix + tol >= dist(k) 
                collision = [collision; [particle(5) candidates(k, 5) particle(4)]];
            end
        end
    end
end
[~,ia,~] = unique(collision(:, 1:2), 'rows'); % remove repeating pairs.
collision = collision(ia, :);
end

