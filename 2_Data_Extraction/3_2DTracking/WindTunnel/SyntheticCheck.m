function correct_percent = SyntheticCheck(origin, detect)
pair_no = unique(detect(:,4));
num_pair = size(pair_no,1);
search_radius = 2;
correct_match = 0;
for i = 1 : num_pair
    pair = detect(detect(:, 4) == i, :);
    particle1 = pair(1,1:2);
    particle_f1_syn = origin(origin(:,3) == 1, :);
    candidate = particle_f1_syn(particle_f1_syn(:,1) > particle1(1) - search_radius ...
    & particle_f1_syn(:,1) < particle1(1) + search_radius ...
    & particle_f1_syn(:,2) > particle1(2) - search_radius ...
    & particle_f1_syn(:,2) < particle1(2) + search_radius, :);
    if isempty(candidate) 
        continue;
    end
    distance = vecnorm(candidate(:, 1:2) - particle1, 2, 2);
    match = candidate(distance == min(distance), :);
    pair_match = origin(origin(:,4) == match(:,4), :);
    if norm(pair_match(2, 1:2) - pair(2, 1:2)) < 1
        correct_match = correct_match + 1;
    end
end
correct_percent = correct_match / num_pair;
end

