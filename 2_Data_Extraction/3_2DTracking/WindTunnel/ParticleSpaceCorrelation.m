function disp_opti = ParticleSpaceCorrelation(particle_ingrid, particleinfo_f2, search_radius)
num_particle = size(particle_ingrid, 1);

search_radius = round(search_radius);

disp_map = zeros(search_radius * 2 + 1, search_radius * 2 + 1);
% radius_max = max(particle_ingrid(:,3:4));
% area_max = radius_max(:,1) * radius_max(:,2);

for i = 1 : num_particle
    candidates = particleinfo_f2(particleinfo_f2(:, 1) > particle_ingrid(i, 1) - search_radius ...
        & particleinfo_f2(:, 1) < particle_ingrid(i, 1) + search_radius ...
        & particleinfo_f2(:, 2) > particle_ingrid(i, 2) - search_radius ...
        & particleinfo_f2(:, 2) < particle_ingrid(i, 2) + search_radius, :);
    for j = 1 : size(candidates, 1)
        disp = round(candidates(j, 1:2) - particle_ingrid(i, 1:2));
        disp_map(disp(1) + search_radius + 1, disp(2) + search_radius + 1) = ...
            disp_map(disp(1) + search_radius + 1, disp(2) + search_radius + 1) ...
            + dot(candidates(j, 3:4), particle_ingrid(i, 3:4)) / ...
            (norm(candidates(j, 3:4)) * norm(particle_ingrid(i, 3:4)));
    end
end
%imagesc(disp_map); check the disp_map
[~, opti_index] = max(disp_map(:));
[x,y] = ind2sub(size(disp_map), opti_index);
if x > 1 && y > 1
    xc = GaussionFit(x - 1, disp_map(x - 1, y), x, disp_map(x, y), x + 1, disp_map(x + 1, y));
    yc = GaussionFit(y - 1, disp_map(x, y - 1), y, disp_map(x, y), y + 1, disp_map(x, y + 1));
    disp_opti = [xc yc] - [round(search_radius) round(search_radius)];
else
    disp_opti = [0 0];
end
end

function xc = GaussionFit(x1, y1, x2, y2, x3, y3)
if y1 == 0
    lnz1 = log(0.001);
else
    lnz1 = log(y1);
end

if y2 == 0
    lnz2 = log(0.001);
else
    lnz2 = log(y2);
end

if y3 == 0
    lnz3 = log(0.001);
else
    lnz3 = log(y3);
end

xc = -0.5 * ((lnz1 * ((x2 * x2) - (x3 * x3))) - (lnz2 * ((x1 * x1) - (x3 * x3))) + ...
    (lnz3 * ((x1 * x1) - (x2 * x2)))) / ((lnz1 * (x3 - x2)) - (lnz3 * (x1 - x2)) + (lnz2 *(x1 - x3)));
end
