function mean_error = PositionCompare(original, tracked)
num_part = size(tracked, 1); 

max_num_part = 2000;
if num_part > max_num_part
    tracked = tracked(randperm(num_part, max_num_part), :); % randomly choose 1000 particles
    num_part = max_num_part;
end
tolerant = 0.05;
error = zeros(num_part, 1);
for i = 1 : num_part
    point =  tracked(i, 1 : 3);
    candidate = original(original(:, 1) > point(1) - tolerant & original(:, 1) < point(1) + tolerant & ...
            original(:, 2) > point(2) - tolerant & original(:, 2) < point(2) + tolerant & ...
            original(:, 3) > point(3) - tolerant & original(:, 3) < point(3) + tolerant, :);
    diff = vecnorm(candidate(:, 1 : 3) - tracked(i, 1 : 3), 2, 2);
    if sum(diff < 0.04) 
        % select the closest one
        error(i) = min(diff);
    end
end

mean_error = mean(nonzeros(error));
end

