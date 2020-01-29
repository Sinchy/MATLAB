function pair_connect = PTV_Relaxation(particleinfo_f1, particleinfo_f2, predictivefield, settings)
% connecting particles between two frames based on the relaxation method
% by Ohmi and Dao Hai Lam 1998

Rs = settings.Rs;
Rn = settings.Rn;
Rc = settings.Rc;
image_size = settings.image_size;
num_grid = settings.grid_number;
thred_prob = settings.thred_prob;
% similar_thred = settings.similar_thred; % the thredshold for comparing connection with neighbour connection.

%Step 1: finding pairs from the next frame within a distance threshold
num_particles = size(particleinfo_f1, 1);
sequence_pairs = cell(num_particles, 1);
for i = 1 : num_particles
    ind_candidates = find(particleinfo_f2(:,1) > particleinfo_f1(i,1) - Rs ...
        & particleinfo_f2(:,1) < particleinfo_f1(i,1) + Rs ...
        & particleinfo_f2(:,2) > particleinfo_f1(i,2) - Rs ...
        & particleinfo_f2(:,2) < particleinfo_f1(i,2) + Rs);
    sequence_pairs{i} = ind_candidates;
end

%Step 2: finding neighbours in the same frame within a distance threshold
neighbour_pairs = cell(num_particles, 1);
for i = 1 : num_particles
    ind_candidates = find(particleinfo_f1(:,1) > particleinfo_f1(i,1) - Rn ...
        & particleinfo_f1(:,1) < particleinfo_f1(i,1) + Rn ...
        & particleinfo_f1(:,2) > particleinfo_f1(i,2) - Rn ...
        & particleinfo_f1(:,2) < particleinfo_f1(i,2) + Rn);
    ind_candidates(ind_candidates == i) = []; % remove the point itself
%     if isempty(ind_candidates) 
%         disp = vecnorm(particleinfo_f1(:, 1:2) - particleinfo_f1(i,1:2), 2, 2);
%         ind_candidates = find(disp == min(nonzeros(disp))); % find the closest neighbour
%     end
    % the neighbour should find at least one sequence_pairs
    is_pairs = 0;
    if ~isempty(ind_candidates)
        for j = 1 : size(ind_candidates, 1)
            is_pairs = is_pairs || size(sequence_pairs{ind_candidates(j)}, 1) > 0;
        end
    end
    if ~is_pairs
        disp = vecnorm(particleinfo_f1(:, 1:2) - particleinfo_f1(i,1:2), 2, 2);
    end
    while(~is_pairs)         
         disp(ind_candidates) = 0;
         ind_candidates = find(disp == min(nonzeros(disp))); 
         is_pairs = size(sequence_pairs{ind_candidates}, 1) > 0;
    end
    % the only neighbour should not share the same sequence pair with the
    % current particle, to avoid mutally enhancement from each other
    is_share = 0;
    if size(ind_candidates, 1) == 1
        if size(sequence_pairs{ind_candidates}, 1) == 1
            if sum(ismember(sequence_pairs{i}, sequence_pairs{ind_candidates}))
                is_share = 1;
            end
        end
    end
    if is_share
        disp = vecnorm(particleinfo_f1(:, 1:2) - particleinfo_f1(i,1:2), 2, 2);
    end
    
    while is_share
        disp(ind_candidates) = 0;
        ind_candidates = find(disp == min(nonzeros(disp))); 
        if size(ind_candidates, 1) == 1
            if size(sequence_pairs{ind_candidates}, 1) == 1
                if sum(ismember(sequence_pairs{i}, sequence_pairs{ind_candidates}))
                    is_share = 1;
                else 
                    is_share = 0;
                end
            end
        end
    end
    
    neighbour_pairs{i} = ind_candidates;
end

%Step 3: Determine the initial value for the probability
probability = cell(num_particles, 1);
grid_length = image_size / num_grid;
[X,Y] = meshgrid(0 : grid_length : image_size);
for i = 1 : num_particles
    disp_est(1) = interp2(X, Y, predictivefield(:, :, 1), particleinfo_f1(i, 1), particleinfo_f1(i, 2));
    disp_est(2) = interp2(X, Y, predictivefield(:, :, 2), particleinfo_f1(i, 1), particleinfo_f1(i, 2));
    num_candidates = size(sequence_pairs{i}, 1);
    if norm(disp_est) ~= 0 
        disp_corr = zeros(num_candidates, 1);
        for j = 1 : num_candidates
            ind_candidate = sequence_pairs{i}(j);
            disp = particleinfo_f2(ind_candidate, 1:2) - particleinfo_f1(i, 1:2); 
            if norm(disp) ~= 0 
                disp_corr(j) = dot(disp_est, disp) / (norm(disp_est) * norm(disp));
            else
                disp_corr(j) = 0;
            end
            if disp_corr(j) < 0 
                disp_corr(j) = 0;
            end
        end
        if ~isempty(disp_corr)
            disp_corr_sum = sum(disp_corr);
            disp_corr_max = max(disp_corr);
        else
            disp_corr_sum = 0;
            disp_corr_max = 0;
        end
        prob_vec = zeros(num_candidates + 1, 1);
        prob_vec(end) = 1 - disp_corr_max;
        for j = 1 : num_candidates
            if disp_corr_sum ~= 0
                prob_vec(j) = disp_corr(j) / disp_corr_sum * disp_corr_max;
            else
                prob_vec(j) = 0;
            end
        end
    else
        prob_vec = ones(num_candidates + 1, 1) / (num_candidates + 1);
    end
    probability{i} = prob_vec;
end

%Step 4: Iteraction: update the probability for each pair based on the
%neighbour pairs.
time_iter = 10;
time = 1;
probability_new = probability;
% A = 0.3;
% B = 3; % A and B should depends on the distance between neighbours
while(time <= time_iter)
    %Step i: update the probability
    for i = 1 : num_particles
        num_candidates = size(sequence_pairs{i}, 1);
        
        for j = 1 : num_candidates
            enhance_prob = 0;
            weaken_prob = 0;
            enhance_max = 0;
            num_neighbours = size(neighbour_pairs{i}, 1);
            for k = 1 : num_neighbours
                ind_neighbour = neighbour_pairs{i}(k);
                num_neighbours_candidates = size(sequence_pairs{ind_neighbour}, 1);
                for l = 1 : num_neighbours_candidates
                    ind_neighbour_candidate = sequence_pairs{ind_neighbour}(l);
                    disp_neighbour = particleinfo_f2(ind_neighbour_candidate, 1:2) - particleinfo_f1(ind_neighbour, 1:2);
                    ind_candidate = sequence_pairs{i}(j);
                    disp_candidate = particleinfo_f2(ind_candidate, 1:2) - particleinfo_f1(i, 1:2);
                    distance = norm(particleinfo_f1(ind_neighbour, 1:2) - particleinfo_f1(i, 1:2));
%                     disp_cor = dot(disp_neighbour, disp_candidate) / norm(disp_neighbour) / norm(disp_candidate);
                    if abs(norm(disp_candidate - disp_neighbour)) < Rc
%                         distance = norm(particleinfo_f1(ind_neighbour, 1:2) - particleinfo_f1(i, 1:2));
                        enhance_prob = enhance_prob + Rn / distance * probability{ind_neighbour}(l); % count the contribution from neighbours based on the distance                 
%                             enhance_prob = enhance_prob + probability{ind_neighbour}(l);
                    else
                        weaken_prob = weaken_prob + Rn / distance * probability{ind_neighbour}(l);  % no similar neighbour will add one to the punishment
                    end
                    if enhance_prob > enhance_max
                        enhance_max = enhance_prob;
                    end
                end
            end
            A = 1 / (weaken_prob + 1);
%             probability_new{i}(j) = probability{i}(j) * (0.3 + 3 * enhance_prob);
              probability_new{i}(j) = probability{i}(j) * (A + enhance_prob);
              if enhance_max ~= 0
                probability_new{i}(end) = probability{i}(end) / (1 + enhance_max); %TODO
              end
%                 probability_new{i}(j) = probability{i}(j) * (0.3 + 3 * enhance_prob);


%             neighbour_prob = 0;
%             num_neighbours = size(neighbour_pairs{i}, 1);
%             for k = 1 : num_neighbours
%                 ind_neighbour = neighbour_pairs{i}(k);
%                 num_neighbours_candidates = size(sequence_pairs{ind_neighbour}, 1);
%                 neighbour_prob_vec = zeros(num_neighbours_candidates, 1);
%                 for l = 1 : num_neighbours_candidates
%                     ind_neighbour_candidate = sequence_pairs{ind_neighbour}(l);
%                     disp_neighbour = particleinfo_f2(ind_neighbour_candidate, 1:2) - particleinfo_f1(ind_neighbour, 1:2);
%                     ind_candidate = sequence_pairs{i}(j);
%                     disp_candidate = particleinfo_f2(ind_candidate, 1:2) - particleinfo_f1(i, 1:2);
%                     distance = norm(particleinfo_f1(ind_neighbour, 1:2) - particleinfo_f1(i, 1:2));
%                     disp_cor = dot(disp_neighbour, disp_candidate) / norm(disp_neighbour) / norm(disp_candidate);
%                     neighbour_prob_vec(l) = Rn / distance * disp_cor / similar_thred * probability{ind_neighbour}(l); % count the contribution from neighbours based on the distance
%                 end
%                 if isempty(neighbour_prob_vec) 
%                     neighbour_prob_vec = 0;
%                 end
%                 neighbour_prob = neighbour_prob + max(neighbour_prob_vec); % only the highest connection of each neighbour will contribute to the current test connection
%             end
%             probability_new{i}(j) = probability{i}(j) * neighbour_prob;

        end
    end
    %Step ii: normalize the probability
    for i = 1 : num_particles
        num_candidates = size(sequence_pairs{i}, 1);
        prob = 0;
        for j = 1 : num_candidates
            prob = prob + probability_new{i}(j);
        end
        for j = 1 : num_candidates
            probability_new{i}(j) = probability_new{i}(j) / (prob + probability_new{i}(end));
        end
        probability_new{i}(end) = probability_new{i}(end) / (prob + probability_new{i}(end));
    end
    probability = probability_new; % update the probability and go for the next iteration.
    time = time + 1;
end

%Step 5: connect the particles
pair_no = 1;
pair_connect = cell(num_particles, 1);
for i = 1 : num_particles
    prob_vec = probability{i};
    ind_prob = find(prob_vec(1:end-1) > thred_prob);
    if ~isempty(ind_prob)
        ind_particle_connect = sequence_pairs{i}(ind_prob);
        pair_connect{i} = [particleinfo_f1(i,1:2) 1 pair_no particleinfo_f1(i,3:4); ...
            particleinfo_f2(ind_particle_connect,1:2) 2 pair_no particleinfo_f2(ind_particle_connect,3:4);];
        pair_no = pair_no + 1;
    end
end
% pair_connect{isempty(pair_connect{:})} = [];
pair_connect = cell2mat(pair_connect);
end

